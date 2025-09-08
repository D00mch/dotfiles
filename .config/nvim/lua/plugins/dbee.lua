-- [nfnl] fnl/plugins/dbee.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function _3_()
  local dbee = require("dbee")
  return dbee.install()
end
local function _4_()
  return kset("n", "<Space>td", ":Dbee toggle<CR>", "Dbee")
end
local function _5_()
  local dbee = require("dbee")
  return dbee.setup({result = {mappings = {{key = "gn", mode = "n", action = "page_next"}, {key = "gp", mode = "n", action = "page_prev"}, {key = "g0", mode = "n", action = "page_first"}, {key = "g9", mode = "n", action = "page_last"}, {key = "yaj", mode = "n", action = "yank_current_json"}, {key = "yaj", mode = "v", action = "yank_selection_json"}, {key = "yaJ", mode = "", action = "yank_all_json"}, {key = "yac", mode = "n", action = "yank_current_csv"}, {key = "yac", mode = "v", action = "yank_selection_csv"}, {key = "yaC", mode = "", action = "yank_all_csv"}, {key = "<D-c>", mode = "", action = "cancel_call"}, {key = "<C-c>", mode = "", action = "cancel_call"}}}, drawer = {mappings = {{key = "r", mode = "n", action = "refresh"}, {key = "<CR>", mode = "n", action = "action_1"}, {key = "r", mode = "n", action = "action_2"}, {key = "d", mode = "n", action = "action_3"}, {key = "o", mode = "n", action = "toggle"}, {key = "<CR>", mode = "n", action = "menu_confirm"}, {key = "y", mode = "n", action = "menu_yank"}, {key = "<Esc>", mode = "n", action = "menu_close"}, {key = "q", mode = "n", action = "menu_close"}}}, editor = {mappings = {{key = "<D-CR>", mode = "v", action = "run_selection"}, {key = "<D-CR>", mode = "n", action = "run_file"}}}})
end
return {{"kndndrj/nvim-dbee", lazy = true, cmd = "Dbee", cond = true, dependencies = {"MunifTanjim/nui.nvim"}, build = _3_, init = _4_, config = _5_}}
