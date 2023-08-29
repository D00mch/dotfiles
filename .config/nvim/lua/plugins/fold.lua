-- [nfnl] Compiled from fnl/plugins/fold.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function _3_()
  do
    local ufo = require("ufo")
    kset("n", "zR", ufo.openAllFolds)
    kset("n", "zM", ufo.closeAllFolds)
  end
  kset("n", "zr", "zMzv", {remap = true})
  vim.o.foldcolumn = "0"
  vim.o.fillchars = "eob: ,fold: ,foldopen:\239\145\188,foldsep: ,foldclose:\239\145\160"
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true
  return nil
end
local function _4_()
  local ufo = require("ufo")
  local handler
  local function _5_(virt_text, lnum, end_lnum, width, truncate)
    local new_virt_text = {}
    local suffix = (" \239\149\129 %d "):format((end_lnum - lnum))
    local suf_width = vim.fn.strdisplaywidth(suffix)
    local target_width = (width - suf_width)
    local cur_width = 0
    for _, chunk in ipairs(virt_text) do
      local chunk_text = chunk[1]
      local chunk_width = vim.fn.strdisplaywidth(chunk_text)
      if (target_width > (cur_width + chunk_width)) then
        table.insert(new_virt_text, chunk)
      else
        chunk_text = truncate(chunk_text, (target_width - cur_width))
        local hl_group = chunk[2]
        table.insert(new_virt_text, {chunk_text, hl_group})
        chunk_width = vim.fn.strdisplaywidth(chunk_text)
        if ((cur_width + chunk_width) < target_width) then
          suffix = (suffix .. (" "):rep(((target_width - cur_width) - chunk_width)))
        else
        end
        break
      end
      cur_width = (cur_width + chunk_width)
    end
    table.insert(new_virt_text, {suffix, "MoreMsg"})
    return new_virt_text
  end
  handler = _5_
  local get_comment_folds
  local function _8_(bufnr)
    local comment_folds = {}
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local is_in_comment = false
    local comment_start = 0
    for i = 0, (line_count - 1) do
      local line = (vim.api.nvim_buf_get_lines(bufnr, i, (i + 1), false))[1]
      if (not is_in_comment and line:match(("^%s*" .. (vim.o.commentstring):sub(1, 1)))) then
        is_in_comment = true
        comment_start = i
      elseif (is_in_comment and not line:match(("^%s*" .. (vim.o.commentstring):sub(1, 1)))) then
        is_in_comment = false
        table.insert(comment_folds, {endLine = (i - 1), startLine = comment_start})
      else
      end
    end
    if is_in_comment then
      table.insert(comment_folds, {endLine = (line_count - 1), startLine = comment_start})
    else
    end
    return comment_folds
  end
  get_comment_folds = _8_
  local with_comment_folds
  local function _11_(bufnr, default)
    local comment_folds = get_comment_folds(bufnr)
    local default_folds = ufo.getFolds(bufnr, default)
    for _, fold in ipairs(comment_folds) do
      table.insert(default_folds, fold)
    end
    return default_folds
  end
  with_comment_folds = _11_
  local ft_map
  local function _12_(_241)
    return with_comment_folds(_241, "indent")
  end
  local function _13_(_241)
    return with_comment_folds(_241, "indent")
  end
  ft_map = {clojure = _12_, markdown = "treesitter", fennel = _13_}
  local function _14_(bufnr, filetype, buftype)
    return ft_map[filetype]
  end
  return ufo.setup({fold_virt_text_handler = handler, provider_selector = _14_})
end
return {{"kevinhwang91/nvim-ufo", dependencies = {"kevinhwang91/promise-async"}, init = _3_, config = _4_}}
