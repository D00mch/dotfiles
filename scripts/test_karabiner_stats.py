"""Regression checks for transparent remapping and persistent aggregate counts."""

import copy
import importlib.util
import json
from pathlib import Path
import socket
import sqlite3
import subprocess
import sys
import tempfile
import time
import unittest


spec = importlib.util.spec_from_file_location("stats", Path(__file__).with_name("karabiner-stats.py"))
stats = importlib.util.module_from_spec(spec)
spec.loader.exec_module(stats)
CONFIG = Path(__file__).resolve().parents[1] / ".config/karabiner/karabiner.json"


class StatsTest(unittest.TestCase):
    def setUp(self):
        self.config = json.loads(CONFIG.read_text())
        stats.instrument(self.config, enabled=False)
        self.rule_count = sum(len(rule["manipulators"]) for profile in self.config["profiles"]
                              for rule in profile.get("complex_modifications", {}).get("rules", []))

    def test_hooks_preserve_every_mapping_and_last_repeat_event(self):
        original = copy.deepcopy(self.config)
        catalog = stats.instrument(self.config)
        self.assertEqual(len(catalog), self.rule_count)
        for before, after in zip(original["profiles"], self.config["profiles"]):
            for a, b in zip(before.get("complex_modifications", {}).get("rules", []),
                            after.get("complex_modifications", {}).get("rules", [])):
                for m, n in zip(a["manipulators"], b["manipulators"]):
                    self.assertEqual(n["to"][1:], m["to"])
                    self.assertEqual(n["to"][-1], m["to"][-1])
        instrumented = copy.deepcopy(self.config)
        self.assertEqual(stats.instrument(self.config), catalog)
        self.assertEqual(self.config, instrumented)
        stats.instrument(self.config, enabled=False)
        self.assertEqual(self.config, original)

    def test_rule_identity_survives_goku_and_reordering_but_not_action_changes(self):
        before = stats.instrument(self.config)
        stats.instrument(self.config, enabled=False)
        rules = self.config["profiles"][1]["complex_modifications"]["rules"]
        rules.reverse()
        self.assertEqual(stats.instrument(self.config), before)
        stats.instrument(self.config, enabled=False)
        rules[0]["manipulators"][0]["to"] = [{"key_code": "f20"}]
        after = stats.instrument(self.config)
        self.assertEqual(len(set(after) - set(before)), 1)

    def test_counts_are_daily_durable_and_ignore_unknown_payloads(self):
        catalog = stats.instrument(self.config)
        rule_id = next(iter(catalog))
        with tempfile.TemporaryDirectory() as directory:
            previous = stats.STATE
            stats.STATE = Path(directory)
            try:
                db = stats.connect()
                stats.save_catalog(db, catalog)
                for _ in range(3):
                    stats.record(db, {stats.MARKER: rule_id}, catalog)
                for bad in (None, [], {}, {stats.MARKER: []}, {stats.MARKER: "unknown"}):
                    stats.record(db, bad, catalog)
                db.close()
                db = stats.connect()
                stats.save_catalog(db, catalog)
                stats.record(db, {stats.MARKER: rule_id}, catalog)
                self.assertEqual(db.execute("SELECT day, rule_id, count FROM counts").fetchall(),
                                 [(stats.date.today().isoformat(), rule_id, 4)])
                self.assertEqual(db.execute("SELECT count(*) FROM rules WHERE active=1").fetchone()[0], self.rule_count)
                db.close()
            finally:
                stats.STATE = previous

    def test_generated_json_round_trip(self):
        stats.instrument(self.config)
        self.assertEqual(json.loads(stats.goku_json(self.config)), self.config)

    def test_receiver_and_goku_regeneration(self):
        with tempfile.TemporaryDirectory(dir="/private/tmp") as directory:
            state = Path(directory)
            config = state / "karabiner.json"
            config.write_text(json.dumps(self.config))
            program = (
                "import importlib.util; from pathlib import Path; "
                f"s=importlib.util.spec_from_file_location('stats', {stats.__file__!r}); "
                "m=importlib.util.module_from_spec(s); s.loader.exec_module(m); "
                f"m.STATE=Path({directory!r}); m.CONFIG=m.STATE/'karabiner.json'; "
                "m.ENDPOINT=m.STATE/'events.sock'; m.serve()"
            )
            process = subprocess.Popen([sys.executable, "-B", "-c", program], stderr=subprocess.PIPE)
            try:
                deadline = time.monotonic() + 8
                while not (state / "counts.sqlite3").exists():
                    self.assertIsNone(process.poll(), process.stderr.read() if process.poll() is not None else "")
                    self.assertLess(time.monotonic(), deadline)
                    time.sleep(0.05)
                with socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM) as client:
                    rule_id = next(iter(stats.instrument(copy.deepcopy(self.config))))
                    for _ in range(25):
                        client.sendto(json.dumps({stats.MARKER: rule_id}).encode(), str(state / "events.sock"))
                with sqlite3.connect(state / "counts.sqlite3") as db:
                    while db.execute("SELECT COALESCE(SUM(count), 0) FROM counts").fetchone()[0] != 25:
                        self.assertLess(time.monotonic(), deadline)
                        time.sleep(0.05)
                # Goku overwrites generated JSON; the receiver must restore hooks.
                config.write_text(json.dumps(self.config))
                while stats.MARKER not in config.read_text():
                    self.assertLess(time.monotonic(), deadline)
                    time.sleep(0.05)
                regenerated = json.loads(config.read_text())
                stats.instrument(regenerated, enabled=False)
                self.assertEqual(regenerated, self.config)
            finally:
                process.terminate()
                process.communicate(timeout=5)
            self.assertEqual(process.returncode, 0)
            self.assertFalse((state / "events.sock").exists())


if __name__ == "__main__":
    unittest.main()
