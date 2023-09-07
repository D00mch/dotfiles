-- [nfnl] Compiled from .config/nvim/fnl/plugins/ssr.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local ssr = require("ssr")
  local _let_2_ = require("config.util")
  local kset = _let_2_["kset"]
  return kset({"n", "x"}, "<Leader>sr", ssr.open, "Search/Replace")
end
return {{"cshuaimin/ssr.nvim", lazy = true, init = _1_, opts = {keymaps = {close = "<D-w>", next_match = "n", prev_match = "N", replace_confirm = "<CR>", replace_all = "<Leader><Cr>"}}, config = true}}
