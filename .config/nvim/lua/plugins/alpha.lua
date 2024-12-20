-- [nfnl] Compiled from fnl/plugins/alpha.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("nfnl.core")
local concat = _local_2_["concat"]
local _local_3_ = autoload("config.util")
local kset = _local_3_["kset"]
local function _4_()
  local sessions = require("session_manager")
  local sconf = require("session_manager.config")
  local startify = require("alpha.themes.startify")
  local alpha = require("alpha")
  sessions.setup({autoload_mode = sconf.AutoloadMode.Disabled})
  kset("n", "<Leader><Space>", ":Alpha<Cr>")
  startify.section.mru.val = {{type = "padding", value = 0}}
  startify.section.top_buttons.val = concat(startify.section.top_buttons.val, {startify.button("l", "Last Session", ":SessionManager load_last_session<Cr>"), startify.button("f", "Files for Session", ":SessionManager load_session<Cr>")})
  startify.section.bottom_buttons.val = {startify.button("t", "Tasks", ":e ~/wiki/todo.md<Cr>"), startify.button("p", "Plugins", ":e ~/dotfiles/.config/nvim/fnl/plugins/basic.fnl<Cr>"), startify.button("i", "Init.fnl", ":e ~/dotfiles/.config/nvim/fnl/config/init.fnl<Cr>"), startify.button("v", "Vimrc", ":e ~/dotfiles/.vimrc<Cr>"), startify.button("z", "Zshrc", ":e ~/dotfiles/.zshrc<Cr>"), startify.button("s", "Scrutch", ":e ~/wiki/scratch.md<Cr>"), startify.button("c", "Career", ":e ~/wiki/programming/career.md<Cr>"), startify.button("w", "Windows", ":e /Volumes/exchange/<Cr>"), startify.button("n", "Nvim packages", ":e ~/.local/share/nvim/site/pack/packer/<Cr>")}
  startify.section.header.val = {"                   __                  ", "     ___   __  __ /\\_\\    ___ ___      ", "   /' _ `\\/\\ \\/\\ \\\\/\\ \\ /' __` __`\\    ", "   /\\ \\/\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\   ", "   \\ \\_\\ \\_\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\  ", "    \\/_/\\/_/\\/__/    \\/_/\\/_/\\/_/\\/_/  "}
  return alpha.setup(startify.config)
end
return {{"goolord/alpha-nvim", dependencies = {"Shatur/neovim-session-manager"}, config = _4_, lazy = false}}
