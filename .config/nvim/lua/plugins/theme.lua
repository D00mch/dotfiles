-- [nfnl] Compiled from .config/nvim/fnl/plugins/theme.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = require("config.which")
local toggle = _local_2_["toggle"]
local _local_3_ = autoload("config.util")
local kset = _local_3_["kset"]
local function dark_3f()
  return (nvim.o.background == "dark")
end
local function transparent_3f()
  return (0 == nvim.g.neovide_transparency)
end
local function make_transparent(dark_3f0)
  vim.g.neovide_transparency = 0
  vim.g.transparency = 0.92
  if dark_3f0 then
    return vim.cmd("let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:transparency))")
  else
    return vim.cmd("let g:neovide_background_color = '#FFFFFF'.printf('%x', float2nr(255 * g:transparency))")
  end
end
local function make_non_transparent(dark_3f0)
  vim.g.neovide_transparency = 1
  vim.g.transparency = 1
  if dark_3f0 then
    return vim.cmd("let g:neovide_background_color = '#0f1117'")
  else
    return vim.cmd("let g:neovide_background_color = '#FFF'")
  end
end
local function set_theme(dark_3f0)
  make_transparent(dark_3f0)
  if dark_3f0 then
    nvim.o.background = "dark"
  else
    nvim.o.background = "light"
  end
  vim.api.nvim_command("colorscheme everforest")
  local function _7_()
    if dark_3f0 then
      return "kanagawa-dragon"
    else
      return "dawnfox"
    end
  end
  return vim.api.nvim_command(("colorscheme " .. _7_()))
end
local default_font = "Hack Nerd Font Mono:h15"
nvim.o.guifont = default_font
local function font_size_21(diff)
  local font = nvim.o.guifont
  local size = (tonumber((nvim.o.guifont):match("h(%d+)$")) + diff)
  nvim.o.guifont = font:gsub("%d+$", size)
  return nil
end
local function _8_()
  if vim.g.neovide then
    nvim.g.neovide_cursor_vfx_mode = "railgun"
    nvim.g.neovide_input_macos_alt_is_meta = true
    local function _9_()
      if transparent_3f() then
        return make_non_transparent(dark_3f())
      else
        return make_transparent(dark_3f())
      end
    end
    toggle("t", "transparency", _9_)
  else
  end
  do
    local everforest = require("everforest")
    local nightfox = require("nightfox")
    everforest.setup({background = "hard"})
    nightfox.setup({options = {styles = {comments = "italic", types = "italic", functions = "bold"}}})
  end
  local function _12_()
    return font_size_21(1)
  end
  kset("n", "<D-=>", _12_)
  local function _13_()
    return font_size_21(-1)
  end
  kset("n", "<D-->", _13_)
  local function _14_()
    nvim.o.guifont = default_font
    return nil
  end
  kset("n", "<D-0>", _14_)
  vim.opt.fillchars = {eob = " "}
  return nil
end
local function _15_()
  local auto = require("auto-dark-mode")
  local function _16_()
    return set_theme(true)
  end
  local function _17_()
    return set_theme(false)
  end
  auto.setup({update_interval = 2000, set_dark_mode = _16_, set_light_mode = _17_})
  return auto.init()
end
return {{"f-person/auto-dark-mode.nvim", priority = 1000, dependencies = {"nvim-tree/nvim-web-devicons", "neanias/everforest-nvim", "sainnhe/edge", "rebelot/kanagawa.nvim", "EdenEast/nightfox.nvim"}, init = _8_, config = _15_, lazy = false}}
