-- [nfnl] Compiled from fnl/plugins/quickfix.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function _3_()
  kset("n", "<Space>pq", "<Cmd>copen<Cr>", "Quickfix")
  kset("n", "]q", ":cn<cr>", "Quickfix: next item")
  return kset("n", "[q", ":cp<cr>", "Quickfix: prev item")
end
return {{"kevinhwang91/nvim-bqf", lazy = true, ft = {"qf"}, init = _3_, opts = {func_map = {}}, config = true}}
