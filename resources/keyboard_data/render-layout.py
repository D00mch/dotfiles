#!/usr/bin/env python3
"""Render the annotated KLE JSON to SVG; uses only the Python standard library.

Labels are maintained manually against karabiner.edn, aerospace.toml and
neru/config.toml. This renders this layout's KLE subset (alignment 0, width).
"""

import json
from html import escape
from pathlib import Path

HERE = Path(__file__).resolve().parent
INK, MUTED = "#edf2f7", "#a6b0bd"
BLUE, ROSE, GREEN, AMBER = "#82b7ff", "#ff92a5", "#8bd5a5", "#efbc68"
UNIT, MARGIN = 156, 48
svg = [
    '<svg xmlns="http://www.w3.org/2000/svg" width="1968" height="1320" '
    'viewBox="0 0 1968 1320" xml:space="preserve" role="img" aria-labelledby="title description">',
    '<title id="title">Custom keyboard bindings</title>',
    '<desc id="description">Compact keyboard with left Command, right Command, '
    'Option and held-semicolon layers, plus Neru, app launchers and AeroSpace modes.</desc>',
    '<style>text { font-family: "DejaVu Sans", "Helvetica Neue", sans-serif; }</style>',
    '<rect width="1968" height="1320" rx="24" fill="#111820"/>',
]


def text(x, y, value, size=20, color=INK, anchor="start", weight=400):
    svg.append(
        f'<text x="{x:g}" y="{y:g}" font-size="{size}" fill="{color}" '
        f'text-anchor="{anchor}" font-weight="{weight}">{escape(value)}</text>'
    )


def rect(x, y, width, height, fill, stroke="#374250", radius=12):
    svg.append(
        f'<rect x="{x:g}" y="{y:g}" width="{width:g}" height="{height:g}" '
        f'rx="{radius}" fill="{fill}" stroke="{stroke}"/>'
    )


text(MARGIN, 65, "Keyboard bindings", 38, weight=600)
text(MARGIN, 103, "Custom global remaps · ABC symbols / Russian legends · app-specific overrides omitted", 21, MUTED)
for x, label, color in [
    (48, "L Cmd  ·  left Command", BLUE),
    (492, "R Cmd  ·  right Command", ROSE),
    (960, "Hold ;  ·  semicolon layer", GREEN),
    (1484, "L Opt  ·  left Option", AMBER),
]:
    rect(x, 137, 7, 24, color, color, 3)
    text(x + 20, 157, label, 23, color, weight=500)

# KLE label indices: base, L Cmd, L Opt, Russian, semicolon, R Cmd.
for row_number, row in enumerate(json.loads((HERE / "keyboard-layout.json").read_text())):
    x, y, width = MARGIN, 200 + row_number * UNIT, 1
    for item in row:
        if isinstance(item, dict):
            width = item.get("w", width)
            continue
        key_width = width * UNIT - 8
        rect(x, y, key_width, UNIT - 8, "#202833")
        labels = item.split("\n") + [""] * 12
        base_color = {"L Cmd": BLUE, "R Cmd": ROSE, "L Opt": AMBER, ";": GREEN}.get(labels[0], INK)
        text(x + 14, y + 37, labels[0], 29, base_color, weight=600)
        for index, tx, ty, size, color, anchor in [
            (8, x + key_width - 14, y + 37, 24, ROSE, "end"),
            (2, x + 14, y + 70, 21, BLUE, "start"),
            (6, x + 14, y + 103, 18, GREEN, "start"),
            (5, x + 14, y + 133, 18, MUTED, "start"),
            (3, x + key_width - 14, y + 133, 21, AMBER, "end"),
        ]:
            if labels[index]:
                text(tx, ty, labels[index], size, color, anchor)
        x += width * UNIT
        width = 1

text(48, 854, "Hold ; + H J K L to focus; add Shift to move.  ; + A floats, centers and enters window mode.", 21, GREEN)
text(48, 884, "Clip shot = selection to clipboard.  Capture UI = screenshot controls.  Tab shortcuts exclude Neovide.  ⌃ = Ctrl  ·  ⌥ = Opt  ·  ⇧ = Shift", 19, MUTED)

panels = [
    (48, "Both Cmd keys + …", BLUE, [
        ("NERU", None),
        ("F  click hints     P  right-click hints", INK),
        ("A  grid               S  scroll", INK),
        ("OPEN APPS", None),
        ("C  Codex            G  Chrome", INK),
        ("I   IntelliJ IDEA    T  Telegram", INK),
        ("N  Neovide         M  WezTerm", INK),
        ("L Cmd + G opens a new Neovide window.", MUTED),
    ]),
    (680, "Resize mode · enter with ; + S", GREEN, [
        ("RELEASE THE CHORD, THEN PRESS", None),
        ("H / L  width − / +     J / K  height + / −", INK),
        ("Q W E R T Y U I O  →  workspaces 1–9", INK),
        ("; + Q … O  →  send window to workspace 1–9", INK),
        ("Arrow keys  →  join with neighbor, then exit", INK),
        ("M  →  move workspace to next monitor", INK),
        ("Esc / Enter  →  exit resize mode", INK),
        ("Workspace switches also exit resize mode.", MUTED),
    ]),
    (1312, "Window mode · enter with ; + G", GREEN, [
        ("RELEASE THE CHORD, THEN PRESS", None),
        ("F  →  toggle floating / tiling", INK),
        ("C  →  float and center", INK),
        ("H J K L  →  move floating window", INK),
        ("← / →  width − / +     ↓ / ↑  height − / +", INK),
        ("R  →  flatten layout and exit", INK),
        ("Shift + R  →  reload config and exit", INK),
        ("Esc  →  exit window mode", INK),
    ]),
]
for x, heading, color, lines in panels:
    rect(x, 920, 600, 330, "#19222c")
    text(x + 22, 957, heading, 23, color, weight=600)
    for number, (line, line_color) in enumerate(lines):
        text(x + 22, 995 + number * 32, line, 16 if line_color is None else 19,
             MUTED if line_color is None else line_color,
             weight=600 if line_color is None else 400)

text(48, 1292, "Sources: Karabiner / Goku · AeroSpace · Neru     |     Diagram shows the compact layout; firmware layers are separate.", 18, MUTED)
svg.append("</svg>")
output = HERE / "keyboard-layout.svg"
output.write_text("\n".join(svg) + "\n")
print(output)
