from xkeysnail.transform import *

define_modmap({
    Key.CAPSLOCK:   Key.ESC,
    Key.ESC:        Key.CAPSLOCK,
    Key.F3:         Key.ENTER,
    Key.F8:         Key.RIGHT_SHIFT,
    Key.F9:         Key.BACKSPACE,
    Key.LEFT_ALT:   Key.LEFT_CTRL,
    Key.LEFT_CTRL:  Key.LEFT_ALT,
})

define_keymap(None, {
    K("Alt-h"): K("left"),
    K("Alt-j"): K("down"),
    K("Alt-k"): K("up"),
    K("Alt-l"): K("right"),

    K("Shift-Alt-h"): K("Shift-left"),
    K("Shift-Alt-j"): K("Shift-down"),
    K("Shift-Alt-k"): K("Shift-up"),
    K("Shift-Alt-l"): K("Shift-right"),

    K("Ctrl-Shift-Alt-h"): K("Ctrl-Shift-left"),
    K("Ctrl-Shift-Alt-j"): K("Ctrl-Shift-down"),
    K("Ctrl-Shift-Alt-k"): K("Ctrl-Shift-up"),
    K("Ctrl-Shift-Alt-l"): K("Ctrl-Shift-right"),
}, "Arrows")
