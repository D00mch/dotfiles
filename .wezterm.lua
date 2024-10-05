local wezterm = require 'wezterm'

--
-- Theme
--

local dimmer = { brightness = 0.05 }
local home = wezterm.home_dir .. '/dotfiles/resources/'


function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Laserwave (Gogh)"
  else
    return "Edge Light (base16)"
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


--
-- Key Binding
--

local act = wezterm.action
local keys = {
  { key = '.', mods = 'CMD', action = act.MoveTabRelative(1) },
  { key = ',', mods = 'CMD', action = act.MoveTabRelative(-1) },
  { key = 'A', mods = 'CMD', action = act.ActivateCommandPalette },
  { key = '[', mods = 'CTRL', action = act.ActivateCopyMode },
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
      key = 'RightArrow',
      mods = 'CMD',
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
      key = 'LeftArrow',
      mods = 'CMD',
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
      action = act.Multiple {
        act.ScrollByLine(-20),
        act.CopyMode { MoveByPage = -0.3 }
      }, 
    },
    {
      key = 'RightArrow',
      mods = 'NONE',
      action = act.Multiple {
        act.ScrollByLine(20),
        act.CopyMode { MoveByPage = 0.3 }
      }, 
    },
    { key = 'UpArrow',
      mods = 'NONE',
      action = act.ScrollByLine(-2),
    },
    {
      key = 'DownArrow',
      mods = 'NONE',
      action = act.ScrollByLine(2),
    },
    {
      key = 'RightArrow',
      mods = 'ALT',
      action = act.CopyMode 'MoveForwardWord',
    },
    {
      key = '/',
      mods = 'NONE',
      action = act.Search 'CurrentSelectionOrEmptyString'
    }
  },
}


--
-- Main Config
--

local config = {
  window_background_opacity = 0.82,
  macos_window_background_blur = 20,

  font = wezterm.font('Terminess Nerd Font', { weight = 'Bold' }),
  font_size = 16,
  keys = keys,
  key_tables = key_tables,
  enable_scroll_bar = false,
  min_scroll_bar_height = '2cell',

  -- Tab Bar
  hide_tab_bar_if_only_one_tab = true,
  show_tab_index_in_tab_bar = false,
}

return config
