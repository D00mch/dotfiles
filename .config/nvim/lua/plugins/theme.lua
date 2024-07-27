-- [nfnl] Compiled from fnl/plugins/theme.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function dark_3f()
  return (nvim.o.background == "dark")
end
local function transparent_3f()
  return (1 ~= vim.g.neovide_transparency)
end
vim.g.neovide_floating_blur_amount_x = 8
vim.g.neovide_floating_blur_amount_y = 8
local function make_transparent()
  vim.g.neovide_transparency = 0.9
  return nil
end
local function make_non_transparent()
  vim.g.neovide_transparency = 1
  return nil
end
local function set_theme(dark_3f0)
  make_transparent(dark_3f0)
  if dark_3f0 then
    nvim.o.background = "dark"
  else
    nvim.o.background = "light"
  end
  vim.api.nvim_command("colorscheme everforest")
  local _4_
  if dark_3f0 then
    _4_ = "kanagawa-dragon"
  else
    _4_ = "dawnfox"
  end
  return vim.api.nvim_command(("colorscheme " .. _4_))
end
local default_font = "Hack Nerd Font Mono:h15"
nvim.o.guifont = default_font
local function font_size_21(diff)
  local font = nvim.o.guifont
  local size = (tonumber(nvim.o.guifont:match("h(%d+)$")) + diff)
  nvim.o.guifont = font:gsub("%d+$", size)
  return nil
end
local function _6_()
  if vim.g.neovide then
    nvim.g.neovide_cursor_vfx_mode = "railgun"
    nvim.g.neovide_input_macos_option_key_is_meta = true
    local function _7_()
      if transparent_3f() then
        return make_non_transparent()
      else
        return make_transparent()
      end
    end
    kset("n", "<Space>tt", _7_, "transparency")
  else
  end
  do
    local everforest = require("everforest")
    local nightfox = require("nightfox")
    everforest.setup({background = "hard"})
    nightfox.setup({options = {styles = {comments = "italic", types = "italic", functions = "bold"}}})
  end
  local function _10_()
    return font_size_21(1)
  end
  kset("n", "<D-=>", _10_)
  local function _11_()
    return font_size_21(-1)
  end
  kset("n", "<D-->", _11_)
  local function _12_()
    nvim.o.guifont = default_font
    return nil
  end
  kset("n", "<D-0>", _12_)
  vim.opt.fillchars = {eob = " "}
  return nil
end
local function _13_()
  local auto = require("auto-dark-mode")
  local function _14_()
    return set_theme(true)
  end
  local function _15_()
    return set_theme(false)
  end
  auto.setup({update_interval = 2000, set_dark_mode = _14_, set_light_mode = _15_})
  return auto.init()
end
return {{"f-person/auto-dark-mode.nvim", priority = 1000, dependencies = {"nvim-tree/nvim-web-devicons", "neanias/everforest-nvim", "sainnhe/edge", "rebelot/kanagawa.nvim", "EdenEast/nightfox.nvim"}, init = _6_, config = _13_, lazy = false}}
