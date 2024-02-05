-- [nfnl] Compiled from fnl/plugins/dbee.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local get_word_under_cursor = _local_2_["get-word-under-cursor"]
local get_word_under_selection = _local_2_["get-word-under-selection"]
local _local_3_ = require("config.which")
local toggle = _local_3_["toggle"]
local function _4_()
  local dbee = require("dbee")
  return dbee.install()
end
local function _5_()
  local dbee = require("dbee")
  local function _6_()
    return dbee.toggle()
  end
  return toggle("d", "Dbee", _6_)
end
local function _7_()
  local dbee = require("dbee")
  return dbee.setup({result = {mappings = {{key = "gn", mode = "n", action = "page_next"}, {key = "gp", mode = "n", action = "page_prev"}, {key = "g0", mode = "n", action = "page_first"}, {key = "g9", mode = "n", action = "page_last"}}}, editor = {mappings = {{key = "<D-CR>", mode = "v", action = "run_selection"}, {key = "<D-CR>", mode = "n", action = "run_file"}}}})
end
return {{"kndndrj/nvim-dbee", dependencies = {"MunifTanjim/nui.nvim"}, build = _4_, init = _5_, config = _7_}}
