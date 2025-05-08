-- [nfnl] fnl/plugins/telescope.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local get_word_under_cursor = _local_2_["get-word-under-cursor"]
local get_word_under_selection = _local_2_["get-word-under-selection"]
local function setup_search_word_under_cursor()
  local builtin = require("telescope.builtin")
  local search_word_under_cursor
  local function _3_()
    local _let_4_ = get_word_under_cursor()
    local word = _let_4_[1]
    return builtin.live_grep({default_text = word})
  end
  search_word_under_cursor = _3_
  local search_word_under_selection
  local function _5_()
    local _let_6_ = get_word_under_selection()
    local word = _let_6_[1]
    return builtin.live_grep({default_text = word})
  end
  search_word_under_selection = _5_
  return kset("n", "<Leader>gr", search_word_under_cursor)
end
local function load_extensions()
  local telescope = require("telescope")
  telescope.load_extension("ui-select")
  telescope.load_extension("ui-select")
  telescope.load_extension("file_browser")
  telescope.load_extension("recent-files")
  return telescope.load_extension("undo")
end
local function _7_()
  kset("n", "<space>pf", ":Telescope find_files hidden=true no_ignore=false<cr>")
  kset("n", "<space>pr", ":Telescope pickers<cr>")
  kset("n", "<space>pb", ":Telescope buffers sort_lastused=true show_all_buffers=false<cr>")
  kset("n", "<space>pa", ":Telescope live_grep<cr>")
  kset("n", "<space>ph", ":Telescope harpoon marks<cr>", "Harpoon")
  kset("n", "<space>pu", ":Telescope undo<Cr>", "Undo")
  kset("n", "<space>vk", ":Telescope keymaps<cr>")
  kset("n", "<space>vc", ":Telescope colorscheme<cr>")
  kset("n", "<space>v:", ":Telescope commands<cr>")
  kset("n", "<space>vo", ":Telescope vim_options<cr>")
  kset("n", "<space>vm", ":Telescope marks<cr>")
  kset("n", "<space>vr", ":Telescope registers<cr>")
  kset("n", "z=", ":Telescope spell_suggest<cr>")
  kset("n", "<space>gc", ":Telescope git_commits<cr>")
  kset("n", "<space>gs", ":Telescope git_stash<cr>")
  return kset("n", "<space>gb", ":Telescope git_branches<cr>")
end
local function _8_()
  local telescope = require("telescope")
  local themes = require("telescope.themes")
  local actions = require("telescope.actions")
  local undo_actions = require("telescope-undo.actions")
  local state = require("telescope.actions.state")
  local mt = require("telescope.actions.mt")
  local M
  local function _9_(prompt_bufnr)
    local entry = state.get_selected_entry(prompt_bufnr)
    vim.fn.setreg("*", entry.value)
    return actions.close(prompt_bufnr)
  end
  M = mt.transform_mod({["yank-entry"] = _9_})
  load_extensions()
  setup_search_word_under_cursor()
  local function _10_()
    return telescope.extensions["recent-files"].recent_files({})
  end
  kset("n", "<space>b", _10_, "search files with priority to recent")
  return telescope.setup({defaults = {vimgrep_arguments = {"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden", "--follow", "-g", "!.git/", "-g", "!.clj-kondo/"}, cache_picker = {num_pickers = 10}, layout_config = {height = 0.9, width = 0.9}, layout_strategy = "vertical", wrap_results = true, mappings = {n = {y = M["yank-entry"], ["<D-w>"] = actions.close, ["<Right>"] = actions.preview_scrolling_down, ["<Left>"] = actions.preview_scrolling_up, t = actions.select_tab, q = (actions.smart_send_to_qflist + actions.open_qflist), ["<Esc>"] = false}, i = {["<M-x>"] = actions.close, ["<C-q>"] = (actions.smart_send_to_qflist + actions.open_qflist), ["?"] = actions.which_key, ["<Right>"] = actions.preview_scrolling_down, ["<Left>"] = actions.preview_scrolling_up, ["<M-d>"] = actions.delete_buffer, ["<M-t>"] = actions.select_tab, ["<M-?>"] = actions.which_key, ["<C-u>"] = false}}}, pickers = {git_branches = {mappings = {n = {["<Cr>"] = actions.git_switch_branch, ga = actions.git_create_branch, gh = actions.git_reset_hard, gs = actions.git_reset_soft, ["<D-m>"] = actions.git_merge_branch, gd = actions.git_delete_branch, gr = actions.git_rebase_branch}, i = {["<Cr>"] = actions.git_switch_branch, ["<M-d>"] = actions.git_delete_branch, ["<C-a>"] = actions.git_create_branch, ["<M-a>"] = actions.git_create_branch, ["<D-a>"] = actions.git_create_branch, ["<C-h>"] = actions.git_reset_hard, ["<C-s>"] = actions.git_reset_soft, ["<C-m>"] = actions.git_merge_branch, ["<C-b>"] = actions.git_rebase_branch, ["<D-b>"] = actions.git_rebase_branch, ["<C-r>"] = actions.git_rebase_branch}}}, git_commits = {mappings = {n = {h = actions.git_reset_hard, ["<Esc>"] = false}, i = {["<Cr>"] = actions.git_checkout_current_buffer}}}, buffers = {sort_mru = true}, live_grep = {only_sort_text = true, additional_args = {"--trim"}}}, extensions = {undo = {mappings = {n = {y = undo_actions.yank_additions, Y = undo_actions.yank_deletions}}}, ["ui-select"] = {themes.get_cursor({})}, frecency = {ignore_patterns = {"*/.git", "*/.git/*", "*/.DS_Store"}, db_safe_mode = false}}})
end
return {{"nvim-telescope/telescope.nvim", dependencies = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim", "debugloop/telescope-undo.nvim", "nvim-telescope/telescope-file-browser.nvim", "mollerhoj/telescope-recent-files.nvim"}, lazy = true, keys = {{"<Space>b", "n"}}, cmd = {"Telescope"}, init = _7_, config = _8_}}
