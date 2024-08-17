-- [nfnl] Compiled from fnl/plugins/oil.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("config.util")
local kset = _local_1_["kset"]
local function _2_()
  return require("oil").open()
end
kset("n", "<Space>f", _2_)
local function _3_()
  local oil = require("oil")
  local actions = require("oil.actions")
  vim.api.nvim_command("set splitright")
  return oil.setup({keymaps = {th = actions.toggle_hidden, ["<Tab>"] = actions.preview, ["<Cr>"] = actions.select, ["<S-Cr>"] = actions.select_vsplit}})
end
return {{"stevearc/oil.nvim", lazy = true, config = _3_}}
