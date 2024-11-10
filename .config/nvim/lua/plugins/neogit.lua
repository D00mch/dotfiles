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
  return kset({"n", "x"}, "<Space>o", neogit_toggle, "Toggle NeoGit")
end
return {{"NeogitOrg/neogit", dependencies = {"nvim-lua/plenary.nvim"}, init = _4_, commit = "9fb8a932d21e03db2dfcf5137e6bd26f2f927d9f", cond = true, opts = {kind = "split", integrations = {diffview = true, telescope = true}, disable_commit_confirmation = true, sections = {untracked = {folded = true}, recent = {folded = true}}, mappings = {status = {o = "Toggle", q = false}, rebase_editor = {b = false, d = false, e = false, f = false, p = false, q = false, r = false, s = false, x = false}}}, config = true, lazy = false}}
