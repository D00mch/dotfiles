-- [nfnl] Compiled from fnl/plugins/dbee.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local get_word_under_cursor = _local_2_["get-word-under-cursor"]
local get_word_under_selection = _local_2_["get-word-under-selection"]
local function _3_()
  local dbee = require("dbee")
  return dbee.install()
end
local function _4_()
  local dbee = require("dbee")
  local function _5_()
    return dbee.toggle()
  end
  return kset("n", "<Space>td", _5_, "Dbee")
end
local function _6_()
  local dbee = require("dbee")
  return dbee.setup({result = {mappings = {{key = "gn", mode = "n", action = "page_next"}, {key = "gp", mode = "n", action = "page_prev"}, {key = "g0", mode = "n", action = "page_first"}, {key = "g9", mode = "n", action = "page_last"}}}, editor = {mappings = {{key = "<D-CR>", mode = "v", action = "run_selection"}, {key = "<D-CR>", mode = "n", action = "run_file"}}}})
end
return {{"kndndrj/nvim-dbee", dependencies = {"MunifTanjim/nui.nvim"}, build = _3_, init = _4_, config = _6_}}
