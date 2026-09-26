#!/usr/bin/env python3
"""Count Karabiner rule activations locally, retaining daily totals only."""

import argparse
import csv
import fcntl
import hashlib
import json
import os
from pathlib import Path
import plistlib
import signal
import socket
import sqlite3
import subprocess
import sys
import tempfile
import time
from datetime import date, timedelta


STATE = Path.home() / ".local/share/karabiner-stats"
CONFIG = Path.home() / ".config/karabiner/karabiner.json"
ENDPOINT = STATE / "events.sock"
LABEL = "local.karabiner-stats"
AGENT = Path.home() / "Library/LaunchAgents" / f"{LABEL}.plist"
MARKER = "dotfiles_karabiner_stats"
MODIFIERS = {
    "left_command": "L⌘", "right_command": "R⌘",
    "left_control": "L⌃", "right_control": "R⌃",
    "left_option": "L⌥", "right_option": "R⌥",
    "left_shift": "L⇧", "right_shift": "R⇧",
}
KEYS = {"semicolon": ";", "comma": ",", "period": ".", "slash": "/",
        "left_arrow": "←", "right_arrow": "→", "up_arrow": "↑", "down_arrow": "↓",
        "return_or_enter": "Enter", "delete_or_backspace": "Backspace",
        "spacebar": "Space", "open_bracket": "[", "close_bracket": "]",
        "equal_sign": "=", "hyphen": "-", "quote": "'", "backslash": "\\"}


def tracking(event):
    payload = event.get("send_user_command", {}).get("payload")
    return isinstance(payload, dict) and MARKER in payload


def chord(event):
    modifiers = event.get("modifiers", [])
    if isinstance(modifiers, dict):
        modifiers = modifiers.get("mandatory", [])
    key = event.get("key_code", event.get("pointing_button", "?"))
    return "+".join([MODIFIERS.get(m, m) for m in modifiers] + [KEYS.get(key, key)])


def describe(manipulator):
    source = chord(manipulator["from"])
    conditions = manipulator.get("conditions", [])
    if any(c.get("name") == "semicolon-mode" and c.get("value") == 1
           for c in conditions):
        source = ";+" + source
    targets = []
    for event in manipulator["to"]:
        if "shell_command" in event:
            targets.append(event["shell_command"])
        elif "set_variable" in event:
            targets.append(event["set_variable"]["name"])
        elif "select_input_source" not in event:
            targets.append(chord(event))
    apps = [c for c in conditions if c.get("type", "").startswith("frontmost_application_")]
    context = " ".join(("except " if c["type"].endswith("unless") else "only ")
                       + ",".join(c.get("bundle_identifiers", [])) for c in apps)
    return source, " → ".join(targets), context


def instrument(config, enabled=True):
    """Prepend telemetry: the last output key must keep its repeat/hold behavior."""
    catalog = {}
    for profile in config.get("profiles", []):
        for rule in profile.get("complex_modifications", {}).get("rules", []):
            for manipulator in rule.get("manipulators", []):
                if "to" not in manipulator:
                    continue
                manipulator["to"] = [e for e in manipulator["to"] if not tracking(e)]
                if not enabled or manipulator.get("type") != "basic" or not manipulator["to"]:
                    continue
                identity = [profile["name"], rule.get("description", ""), manipulator]
                rule_id = hashlib.sha256(json.dumps(identity, sort_keys=True).encode()).hexdigest()[:20]
                source, target, context = describe(manipulator)
                active = profile.get("selected", False) and rule.get("enabled", True)
                catalog[rule_id] = (profile["name"], rule.get("description", ""),
                                    source, target, context, int(active))
                manipulator["to"].insert(0, {"send_user_command": {
                    "endpoint": str(ENDPOINT), "payload": {MARKER: rule_id}}})
    return catalog


def goku_json(value, level=0):
    """Keep Goku/Jackson's formatting so generated diffs contain only our hooks."""
    if isinstance(value, dict) and value:
        lines = ["  " * (level + 1) + json.dumps(k) + " : " + goku_json(v, level + 1)
                 for k, v in value.items()]
        return "{\n" + ",\n".join(lines) + "\n" + "  " * level + "}"
    if isinstance(value, list):
        return "[ " + ", ".join(goku_json(v, level) for v in value) + " ]"
    return json.dumps(value, ensure_ascii=False)


def update_config(enabled=True):
    original = CONFIG.read_text()
    config = json.loads(original)
    before = json.dumps(config)
    catalog = instrument(config, enabled)
    if json.dumps(config) != before:
        with tempfile.NamedTemporaryFile(mode="w", dir=CONFIG.parent, delete=False) as output:
            temporary = Path(output.name)
            output.write(goku_json(config) + "\n")
        try:
            if CONFIG.read_text() != original:
                raise RuntimeError("Karabiner config changed during update; retrying")
            os.chmod(temporary, CONFIG.stat().st_mode & 0o777)
            os.replace(temporary, CONFIG.resolve())
        finally:
            temporary.unlink(missing_ok=True)
    return catalog


def connect():
    db = sqlite3.connect(STATE / "counts.sqlite3")
    db.execute("PRAGMA journal_mode=WAL")
    db.executescript("""
        CREATE TABLE IF NOT EXISTS rules (
            id TEXT PRIMARY KEY, profile TEXT, section TEXT, shortcut TEXT,
            target TEXT, context TEXT, active INTEGER);
        CREATE TABLE IF NOT EXISTS counts (
            day TEXT, rule_id TEXT, count INTEGER NOT NULL,
            PRIMARY KEY (day, rule_id));
    """)
    return db


def save_catalog(db, catalog):
    with db:
        db.execute("UPDATE rules SET active=0")
        db.executemany("INSERT OR REPLACE INTO rules VALUES (?, ?, ?, ?, ?, ?, ?)",
                       [(key, *value) for key, value in catalog.items()])


def record(db, payload, catalog):
    if not isinstance(payload, dict):
        return
    rule_id = payload.get(MARKER)
    if not isinstance(rule_id, str) or rule_id not in catalog:
        return
    with db:
        db.execute("""INSERT INTO counts VALUES (?, ?, 1)
                      ON CONFLICT(day, rule_id) DO UPDATE SET count=count+1""",
                   (date.today().isoformat(), rule_id))


def serve():
    STATE.mkdir(parents=True, exist_ok=True, mode=0o700)
    # Do not unlink a live receiver when a second instance is started.
    with (STATE / "receiver.lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        ENDPOINT.unlink(missing_ok=True)
        with socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM) as receiver:
            receiver.bind(str(ENDPOINT))
            receiver.settimeout(1)
            db = connect()
            catalog = {}
            signature = None
            next_check = 0
            stopping = False

            def stop(*_):
                nonlocal stopping
                stopping = True

            signal.signal(signal.SIGTERM, stop)
            signal.signal(signal.SIGINT, stop)
            try:
                while not stopping:
                    if time.monotonic() >= next_check:
                        next_check = time.monotonic() + 2
                        try:
                            current = CONFIG.stat().st_mtime_ns
                            if current != signature:
                                catalog = update_config()
                                save_catalog(db, catalog)
                                signature = CONFIG.stat().st_mtime_ns
                        except (OSError, ValueError, RuntimeError) as error:
                            print(error, file=sys.stderr, flush=True)
                    try:
                        payload = json.loads(receiver.recv(4096))
                        record(db, payload, catalog)
                    except socket.timeout:
                        pass
                    except (ValueError, UnicodeDecodeError):
                        pass
            finally:
                db.close()
                ENDPOINT.unlink(missing_ok=True)


def report(args):
    database = STATE / "counts.sqlite3"
    if not database.exists():
        raise SystemExit("Not installed. Run: python3 scripts/karabiner-stats.py install")
    since = (date.today() - timedelta(days=args.days - 1)).isoformat() if args.days else "0000-00-00"
    with sqlite3.connect(f"{database.as_uri()}?mode=ro", uri=True) as db:
        rows = db.execute("""
            SELECT COALESCE(SUM(c.count), 0), r.shortcut, r.section, r.target, r.context
            FROM rules r LEFT JOIN counts c ON c.rule_id=r.id AND c.day>=?
            WHERE r.active=1 GROUP BY r.id ORDER BY 1 DESC, r.section, r.shortcut
        """, (since,)).fetchall()
    if args.csv:
        writer = csv.writer(sys.stdout)
        writer.writerow(["count", "shortcut", "section", "target", "context"])
        writer.writerows(rows)
        return
    print(f"{sum(r[0] for r in rows)} activations | {len(rows)} active rules | "
          + (f"last {args.days} days" if args.days else "all time"))
    print("One count per press; auto-repeat is not counted. L/R = left/right modifier.\n")
    for count, shortcut, section, target, context in (rows if args.all else rows[:20]):
        print(f"{count:7}  {shortcut:24} [{section}] → {target}" + (f" ({context})" if context else ""))
    if not args.all and len(rows) > 20:
        print(f"\nShowing top 20; --all shows all {len(rows)} rules, including unused ones.")


def install():
    cli = "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"
    version = subprocess.check_output([cli, "--version"], text=True).strip()
    if tuple(map(int, version.split("."))) < (16, 3, 0):
        raise SystemExit("This counter requires Karabiner-Elements 16.3.0 or newer")
    STATE.mkdir(parents=True, exist_ok=True, mode=0o700)
    if len(os.fsencode(ENDPOINT)) >= 104:
        raise SystemExit("Socket path is too long for macOS")
    backup = STATE / "karabiner-before-stats.json"
    if not backup.exists():
        backup.write_bytes(CONFIG.read_bytes())
    AGENT.parent.mkdir(parents=True, exist_ok=True)
    agent = {"Label": LABEL, "ProgramArguments": [sys.executable, str(Path(__file__).resolve()), "serve"],
             "RunAtLoad": True, "KeepAlive": True, "ThrottleInterval": 10,
             "Umask": 0o077, "StandardErrorPath": str(STATE / "receiver.log")}
    AGENT.write_bytes(plistlib.dumps(agent))
    target = f"gui/{os.getuid()}"
    subprocess.run(["launchctl", "bootout", f"{target}/{LABEL}"], capture_output=True)
    subprocess.run(["launchctl", "bootstrap", target, str(AGENT)], check=True)
    print(f"Installed. Daily counts: {STATE / 'counts.sqlite3'}")


def uninstall():
    subprocess.run(["launchctl", "bootout", f"gui/{os.getuid()}/{LABEL}"], capture_output=True)
    update_config(enabled=False)
    AGENT.unlink(missing_ok=True)
    print(f"Disabled; saved statistics remain in {STATE}")


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["install", "serve", "report", "uninstall"], default="report", nargs="?")
    parser.add_argument("--all", action="store_true", help="show every active rule, including zeros")
    parser.add_argument("--days", type=int, help="include today and the previous N-1 days")
    parser.add_argument("--csv", action="store_true", help="export every active rule as CSV")
    args = parser.parse_args()
    if args.days is not None and args.days < 1:
        parser.error("--days must be positive")
    if args.command == "report":
        report(args)
    else:
        {"install": install, "serve": serve, "uninstall": uninstall}[args.command]()


if __name__ == "__main__":
    main()
