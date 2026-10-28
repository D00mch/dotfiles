-- [nfnl] fnl/plugins/theme.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local function dark_3f()
  return (nvim.o.background == "dark")
end
local function transparent_3f()
  return ((vim.g.neovide_opacity or 1) < 1)
end
vim.g.neovide_floating_blur_amount_x = 2
vim.g.neovide_floating_blur_amount_y = 2
local function make_transparent()
  if dark_3f() then
    vim.g.neovide_opacity = 0.87
  else
    vim.g.neovide_opacity = 0.77
  end
  vim.g.neovide_window_blurred = true
  return nil
end
local function make_non_transparent()
  vim.g.neovide_opacity = 1
  vim.g.neovide_window_blurred = false
  return nil
end
local function set_theme(dark_3f0)
  if dark_3f0 then
    nvim.o.background = "dark"
  else
    nvim.o.background = "light"
  end
  if transparent_3f() then
    make_transparent()
  else
  end
  local _6_
  if dark_3f0 then
    _6_ = "suannhai-lam-ni"
  else
    _6_ = "suannhai-shironeri"
  end
  return vim.api.nvim_command(("colorscheme " .. _6_))
end
local default_font = "Terminalia,Terminess_Nerd_Font:h19"
nvim.o.guifont = default_font
local function font_size_21(diff)
  local font = nvim.o.guifont
  local size = (tonumber(nvim.o.guifont:match("h(%d+)$")) + diff)
  nvim.o.guifont = font:gsub("%d+$", size)
  return nil
end
local function _8_()
  if vim.g.neovide then
    make_transparent()
    nvim.g.neovide_cursor_vfx_mode = "pixiedust"
    nvim.g.neovide_input_macos_option_key_is_meta = "none"
    local function _9_()
      if transparent_3f() then
        return make_non_transparent()
      else
        return make_transparent()
      end
    end
    kset("n", "<Space>tt", _9_, "transparency")
  else
  end
  local function _12_()
    return font_size_21(1)
  end
  kset("n", "<D-+>", _12_)
  local function _13_()
    return font_size_21(-1)
  end
  kset("n", "<D-->", _13_)
  local function _14_()
    nvim.o.guifont = default_font
    return nil
  end
  kset("n", "<leader>sd", _14_, "Default font size")
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
return {{"f-person/auto-dark-mode.nvim", priority = 1000, dependencies = {"nvim-tree/nvim-web-devicons"}, init = _8_, config = _15_, lazy = false}}
