-- [nfnl] Compiled from fnl/plugins/diffview.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local _local_3_ = autoload("nfnl.core")
local merge = _local_3_["merge"]
local function history_toggle()
  local _ = require("diffview")
  local current_dir = vim.fn.expand("%")
  local in_annotate_3f = string.match(current_dir, "DiffviewFileHistoryPanel$")
  local function _4_()
    if in_annotate_3f then
      return "q"
    else
      return "DiffviewFileHistory %"
    end
  end
  return vim.api.nvim_command(_4_())
end
local function _5_()
  kset({"n"}, "<space>gh", history_toggle, "Toggle git history")
  kset({"x"}, "<space>gh", ":DiffviewFileHistory<cr>", "Toggle git history")
  return kset({"n"}, "<space>gv", ":DiffviewOpen ", "DiffviewOpen")
end
local function _6_()
  local dview = require("diffview")
  local actions = require("diffview.actions")
  local ufo = require("ufo")
  local diffview_common_mappings = {gf = actions.goto_file_edit, ["<Space>m"] = ":DiffviewToggleFiles<cr>", [":ggn"] = actions.next_conflict, [":ggp"] = actions.prev_conflict}
  local diffview_unmap = {["<esc>"] = false, ["<leader>b"] = false, ["<leader>ca"] = false, ["<leader>cb"] = false, ["<leader>co"] = false, ["<leader>ct"] = false, ["<leader>e"] = false, ["[x"] = false, ["]x"] = false, dx = false, q = false}
  local panel_mappings = merge(diffview_unmap, diffview_common_mappings, {x = actions.restore_entry, s = actions.toggle_stage_entry})
  local diff_keys = {{{"n", "x"}, "go", actions.conflict_choose("ours")}, {{"n", "x"}, "gt", actions.conflict_choose("theirs")}, {{"n", "x"}, "gb", actions.conflict_choose("base")}, {{"n", "x"}, "ga", actions.conflict_choose("all")}, {{"n", "x"}, "gn", actions.next_conflict}, {{"n", "x"}, "gN", actions.prev_conflict}}
  local function _7_(_)
    return ufo.detach()
  end
  return dview.setup({view = {merge_tool = {layout = "diff1_plain"}}, hooks = {diff_buf_read = _7_}, keymaps = {view = merge(diffview_unmap, diffview_common_mappings), diff1 = diff_keys, diff3 = diff_keys, file_panel = panel_mappings, file_history_panel = panel_mappings, option_panel = panel_mappings, disable_defaults = false}})
end
return {{"sindrets/diffview.nvim", lazy = true, cmd = {"DiffviewOpen", "DiffviewFileHistory"}, init = _5_, config = _6_}}
