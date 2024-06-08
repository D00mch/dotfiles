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
local function _4_()
  return kset({"n", "x"}, "<Space>9", neogit_toggle, "Toggle NeoGit")
end
return {{"TimUntersberger/neogit", dependencies = {"nvim-lua/plenary.nvim"}, init = _4_, lazy = true, opts = {kind = "split", integrations = {diffview = true, telescope = true}, disable_commit_confirmation = true, sections = {untracked = {folded = true}, recent = {folded = true}}, mappings = {status = {o = "Toggle", q = false}}}, config = true, cond = false}}
