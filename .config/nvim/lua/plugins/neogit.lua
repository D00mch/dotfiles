-- [nfnl] Compiled from fnl/plugins/neogit.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function neogit_toggle()
  local current_dir = vim.fn.expand("%")
  local in_git_3f = string.match(current_dir, "NeogitStatus$")
  local diff_view_3f = string.match(current_dir, "^diffview://")
  local function _3_()
    if diff_view_3f then
      return "tabc"
    elseif in_git_3f then
      return "bd"
    else
      return "Neogit"
    end
  end
  return vim.api.nvim_command(_3_())
end
return {}
