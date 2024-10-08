-- [nfnl] Compiled from fnl/plugins/fugitive.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function annotate_toggle()
  local current_dir = vim.fn.expand("%")
  local in_annotate_3f = string.match(current_dir, "fugitiveblame$")
  local function _3_()
    if in_annotate_3f then
      return "q"
    else
      return "G blame"
    end
  end
  return vim.api.nvim_command(_3_())
end
local function fugitive_toggle()
  local current_dir = vim.fn.expand("%")
  local in_git_3f = string.match(current_dir, "^fugitive://")
  local diff_view_3f = string.match(current_dir, "^diffview://")
  local function _4_()
    if diff_view_3f then
      return "tabc"
    elseif in_git_3f then
      return "bd"
    elseif in_git_3f then
      return "q"
    else
      return "G"
    end
  end
  return vim.api.nvim_command(_4_())
end
local function _5_()
  vim.api.nvim_command("set splitbelow")
  return kset({"n", "x"}, "<Space>o", fugitive_toggle)
end
return {{"tpope/vim-fugitive", cond = true, init = _5_}}
