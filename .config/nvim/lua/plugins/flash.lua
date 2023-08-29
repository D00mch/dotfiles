-- [nfnl] Compiled from fnl/plugins/flash.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local english = "asdfghjklqwertyuiopzxcvbnm"
local function _3_()
  local flash = require("flash")
  return kset({"n", "x", "o"}, "q", flash.jump)
end
return {{"folke/flash.nvim", init = _3_, opts = {labels = english, modes = {char = {enabled = false}, search = {enabled = false}, treesitter = {enabled = false}}, label = {rainbow = {shade = 5, enabled = false}, before = true, style = "inline", uppercase = false, after = false}}, config = true}}
