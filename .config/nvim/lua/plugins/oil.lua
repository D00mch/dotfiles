-- [nfnl] Compiled from fnl/plugins/oil.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function _3_()
  local oil = require("oil")
  local actions = require("oil.actions")
  kset("n", "<Space>ff", oil.open)
  return oil.setup({keymaps = {th = actions.toggle_hidden, ["<Tab>"] = actions.preview, ["<Cr>"] = actions.select_vsplit, ["<S-Cr>"] = actions.select}})
end
return {{"stevearc/oil.nvim", config = _3_}}
