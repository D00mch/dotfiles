-- [nfnl] Compiled from .config/nvim/fnl/plugins/ssr.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function _3_()
  local ssr = require("ssr")
  return kset({"n", "x"}, "<Leader>sr", ssr.open, "Search/Replace")
end
return {{"cshuaimin/ssr.nvim", init = _3_, opts = {keymaps = {close = "<D-w>", next_match = "n", prev_match = "N", replace_confirm = "<CR>", replace_all = "<Leader><Cr>"}}, config = true}}
