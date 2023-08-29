-- [nfnl] Compiled from fnl/plugins/markdown.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("config.which")
local toggle = _local_2_["toggle"]
local _local_3_ = autoload("nfnl.core")
local map = _local_3_["map"]
local first = _local_3_["first"]
local last = _local_3_["last"]
local _local_4_ = autoload("config.util")
local kset = _local_4_["kset"]
local get_word_under_cursor = _local_4_["get-word-under-cursor"]
local get_word_under_selection = _local_4_["get-word-under-selection"]
local function _5_()
end
local function _6_()
end
return {{"jghauser/follow-md-links.nvim", dependencies = {"iamcco/markdown-preview.nvim"}, init = _5_, config = _6_}}
