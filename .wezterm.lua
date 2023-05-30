local wezterm = require 'wezterm'

--
-- Theme
--

local dimmer = { brightness = 0.05 }
local home = wezterm.home_dir .. '/dotfiles/resources/'
local paralax_bg = {
  {
    source = {
      File = home..'Alien_Ship_bg_vert_images/Backgrounds/spaceship_bg_1@2x.png',
    },
    repeat_x = 'Mirror',
    hsb = dimmer,
    attachment = { Parallax = 0.1 },
  },
  {
    source = {
      File = home .. 'Alien_Ship_bg_vert_images/Overlays/overlay_1_spines@2x.png',
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
      File = home .. 'Alien_Ship_bg_vert_images/Overlays/overlay_2_alienball@2x.png',
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
      File = home .. 'Alien_Ship_bg_vert_images/Overlays/overlay_3_lobster@2x.png',
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
      File = home .. 'Alien_Ship_bg_vert_images/Overlays/overlay_4_spiderlegs@2x.png',
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


--
-- Key Binding
--

local act = wezterm.action
local keys = {
  { key = '.', mods = 'CMD', action = act.MoveTabRelative(1) },
  { key = ',', mods = 'CMD', action = act.MoveTabRelative(-1) },
  { key = 'A', mods = 'CMD', action = act.ActivateCommandPalette },
  { key = 'Escape', mods = 'CMD', action = act.ActivateCopyMode },
}
local key_tables = {
  copy_mode = {
    { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    {
      key = 'Tab',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveBackwardWord',
    },
    {
      key = 'Enter',
      mods = 'NONE',
      action = act.CopyMode 'MoveToStartOfNextLine',
    },
    { key = 'i', mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'ClearSelectionMode' },
    {
      key = 'Space',
      mods = 'NONE',
      action = act.CopyMode { SetSelectionMode = 'Cell' },
    },
    {
      key = '$',
      mods = 'NONE',
      action = act.CopyMode 'MoveToEndOfLineContent',
    },
    {
      key = '$',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToEndOfLineContent',
    },
    { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
    { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
    {
      key = 'F',
      mods = 'NONE',
      action = act.CopyMode { JumpBackward = { prev_char = false } },
    },
    {
      key = 'F',
      mods = 'SHIFT',
      action = act.CopyMode { JumpBackward = { prev_char = false } },
    },
    {
      key = 'G',
      mods = 'NONE',
      action = act.CopyMode 'MoveToScrollbackBottom',
    },
    {
      key = 'G',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToScrollbackBottom',
    },
    { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
    {
      key = 'H',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToViewportTop',
    },
    {
      key = 'L',
      mods = 'NONE',
      action = act.CopyMode 'MoveToViewportBottom',
    },
    {
      key = 'L',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToViewportBottom',
    },
    {
      key = 'M',
      mods = 'NONE',
      action = act.CopyMode 'MoveToViewportMiddle',
    },
    {
      key = 'M',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToViewportMiddle',
    },
    {
      key = 'O',
      mods = 'NONE',
      action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
    },
    {
      key = 'O',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
    },
    {
      key = 'T',
      mods = 'NONE',
      action = act.CopyMode { JumpBackward = { prev_char = true } },
    },
    {
      key = 'T',
      mods = 'SHIFT',
      action = act.CopyMode { JumpBackward = { prev_char = true } },
    },
    {
      key = 'V',
      mods = 'NONE',
      action = act.CopyMode { SetSelectionMode = 'Line' },
    },
    {
      key = 'V',
      mods = 'SHIFT',
      action = act.CopyMode { SetSelectionMode = 'Line' },
    },
    {
      key = '^',
      mods = 'NONE',
      action = act.CopyMode 'MoveToStartOfLineContent',
    },
    {
      key = '^',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToStartOfLineContent',
    },
    { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
    { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
    {
      key = 'd',
      mods = 'CTRL',
      action = act.CopyMode { MoveByPage = 0.5 },
    },
    {
      key = 'e',
      mods = 'NONE',
      action = act.CopyMode 'MoveForwardWordEnd',
    },
    {
      key = 'f',
      mods = 'NONE',
      action = act.CopyMode { JumpForward = { prev_char = false } },
    },
    { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
    { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
    {
      key = 'g',
      mods = 'NONE',
      action = act.CopyMode 'MoveToScrollbackTop',
    },
    { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
    { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
    {
      key = 'm',
      mods = 'ALT',
      action = act.CopyMode 'MoveToStartOfLineContent',
    },
    {
      key = 'o',
      mods = 'NONE',
      action = act.CopyMode 'MoveToSelectionOtherEnd',
    },
    { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
    {
      key = 't',
      mods = 'NONE',
      action = act.CopyMode { JumpForward = { prev_char = true } },
    },
    {
      key = 'u',
      mods = 'CTRL',
      action = act.CopyMode { MoveByPage = -0.5 },
    },
    {
      key = 'v',
      mods = 'NONE',
      action = act.CopyMode { SetSelectionMode = 'Cell' },
    },
    {
      key = 'v',
      mods = 'CTRL',
      action = act.CopyMode { SetSelectionMode = 'Block' },
    },
    { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    {
      key = 'y',
      mods = 'NONE',
      action = act.Multiple {
        { CopyTo = 'ClipboardAndPrimarySelection' },
        { CopyMode = 'Close' },
      },
    },
    { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
    { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
    {
      key = 'End',
      mods = 'NONE',
      action = act.CopyMode 'MoveToEndOfLineContent',
    },
    {
      key = 'Home',
      mods = 'NONE',
      action = act.CopyMode 'MoveToStartOfLine',
    },
    { key = 'LeftArrow',
      mods = 'NONE',
      action = act.CopyMode { MoveByPage = -0.2 }, 
    },
    {
      key = 'LeftArrow',
      mods = 'ALT',
      action = act.CopyMode 'MoveBackwardWord',
    },
    {
      key = 'RightArrow',
      mods = 'NONE',
      action = act.CopyMode { MoveByPage = 0.2 },
    },
    {
      key = 'RightArrow',
      mods = 'ALT',
      action = act.CopyMode 'MoveForwardWord',
    },
    { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
  },
}


--
-- Main Config
--

local config = {
  font = wezterm.font('Hack Nerd Font Mono', { weight = 'Bold' }),
  font_size = 14,
  keys = keys,
  key_tables = key_tables,
  enable_scroll_bar = true,
  min_scroll_bar_height = '2cell',
}

return config
