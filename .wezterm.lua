local wezterm = require 'wezterm'
local act = wezterm.action

function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "SeaShells"
  else
    return "dawnfox"
  end
end

wezterm.on("window-config-reloaded", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = window:get_appearance()
  local scheme = scheme_for_appearance(appearance)
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

local config = {
  font = wezterm.font('Hack Nerd Font Mono', { weight = 'Bold' }),
  font_size = 14,
  enable_scroll_bar = true,
  keys = {
    { key = '.', mods = 'CMD', action = act.MoveTabRelative(1) },
    { key = ',', mods = 'CMD', action = act.MoveTabRelative(-1) },
  }
}

return config
