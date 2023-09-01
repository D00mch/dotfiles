-- [nfnl] Compiled from .config/nvim/fnl/plugins/sexp.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("nfnl.core")
local some = _local_2_["some"]
local _local_3_ = autoload("config.util")
local kset = _local_3_["kset"]
local lisps = {"clojure", "scheme", "lisp", "cl", "timl", "fennel", "janet"}
local function _4_()
  local function _5_(_2410)
    return (vim.bo.filetype == _2410)
  end
  if some(_5_, lisps) then
    nvim.g.sexp_enable_insert_mode_mappings = 1
  else
    nvim.g.sexp_enable_insert_mode_mappings = 0
  end
  return nil
end
vim.api.nvim_create_autocmd("Filetype", {pattern = "*", group = vim.api.nvim_create_augroup("SexpInsert", {clear = true}), callback = _4_})
local function _7_()
  nvim.g.sexp_filetypes = "*"
  nvim.g.sexp_insert_after_wrap = 0
  nvim.g.sexp_mappings = {sexp_capture_next_element = "<space>ks", sexp_capture_prev_element = "<space>kS", sexp_emit_tail_element = "<space>kb", sexp_emit_head_element = "<space>kB", sexp_round_head_wrap_element = "<leader>a", sexp_round_tail_wrap_element = "<leader>f", sexp_square_head_wrap_element = "<leader>[", sexp_square_tail_wrap_element = "<leader>]", sexp_curly_head_wrap_element = "<leader>{", sexp_curly_tail_wrap_element = "<leader>}", sexp_square_head_wrap_list = "", sexp_square_tail_wrap_list = "", sexp_curly_head_wrap_list = "", sexp_curly_tail_wrap_list = "", sexp_move_to_next_element_tail = "<space>mr", sexp_move_to_prev_element_tail = "<space>ml", sexp_move_to_next_top_element = "<space>mb", sexp_move_to_prev_top_element = "<space>mh", sexp_indent = "", sexp_indent_top = "", sexp_round_tail_wrap_list = "", sexp_round_head_wrap_list = "", sexp_insert_at_list_head = "", sexp_swap_list_forward = "<C-j>", sexp_swap_list_backward = "<C-k>", sexp_swap_element_backward = "<C-h>", sexp_swap_element_forward = "<C-l>"}
  kset({"n"}, "<Leader>c", "gcaf", {remap = true})
  return kset({"n", "x"}, "<M-up>", "vaf", {remap = true})
end
return {{"guns/vim-sexp", dependencies = {"tpope/vim-sexp-mappings-for-regular-people", "tpope/vim-repeat", "tpope/vim-surround"}, init = _7_}}
