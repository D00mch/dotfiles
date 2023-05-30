local wezterm = require 'wezterm'
local act = wezterm.action

local dimmer = { brightness = 0.05 }
local home = wezterm.home_dir .. '/dotfiles/resources/'
local paralax_bg = {
  {
    source = {
      File = home..'Alien_Ship_bg_vert_images/Backgrounds/spaceship_bg_1.png',
    },
    repeat_x = 'Mirror',
    hsb = dimmer,
    attachment = { Parallax = 0.1 },
  },
  {
    source = {
      File = home .. 'Alien_Ship_bg_vert_images/Overlays/overlay_1_spines.png',
    },
    width = '100%',
    repeat_x = 'NoRepeat',
    vertical_align = 'Bottom',
    repeat_y_size = '200%',
    hsb = dimmer,
    attachment = { Parallax = 0.2 },
  },
  {
    source = {
      File = home .. 'Alien_Ship_bg_vert_images/Overlays/overlay_2_alienball.png',
    },
    width = '100%',
    repeat_x = 'NoRepeat',
    vertical_offset = '10%',
    repeat_y_size = '200%',
    hsb = dimmer,
    attachment = { Parallax = 0.3 },
  },
  {
    source = {
      File = home .. 'Alien_Ship_bg_vert_images/Overlays/overlay_3_lobster.png',
    },
    width = '100%',
    repeat_x = 'NoRepeat',
    vertical_offset = '30%',
    repeat_y_size = '200%',
    hsb = dimmer,
    attachment = { Parallax = 0.4 },
  },
  {
    source = {
      File = home .. 'Alien_Ship_bg_vert_images/Overlays/overlay_4_spiderlegs.png',
    },
    width = '100%',
    repeat_x = 'NoRepeat',
    vertical_offset = '50%',
    repeat_y_size = '150%',
    hsb = dimmer,
    attachment = { Parallax = 0.5 },
  },
}

function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "SeaShells"
  else
    return "dawnfox"
  end
end

function bg_scheme(appearance)
  if appearance:find("Dark") then
    return paralax_bg
  else
    return {}
  end
end

wezterm.on("window-config-reloaded", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = window:get_appearance()
  local scheme = scheme_for_appearance(appearance)
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    overrides.background = bg_scheme(appearance)
    window:set_config_overrides(overrides)
  end
end)

local config = {
  font = wezterm.font('Hack Nerd Font Mono', { weight = 'Bold' }),
  font_size = 14,
  keys = {
    { key = '.', mods = 'CMD', action = act.MoveTabRelative(1) },
    { key = ',', mods = 'CMD', action = act.MoveTabRelative(-1) },
  },
  enable_scroll_bar = true,
  min_scroll_bar_height = '2cell',
}

return config
