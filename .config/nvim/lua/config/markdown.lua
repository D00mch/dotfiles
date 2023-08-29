-- [nfnl] Compiled from fnl/config/markdown.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("config.which")
local toggle = _local_2_["toggle"]
local _local_3_ = autoload("nfnl.core")
local first = _local_3_["first"]
local last = _local_3_["last"]
local map = _local_3_["map"]
local _local_4_ = autoload("nfnl.string")
local join = _local_4_["join"]
local _local_5_ = autoload("config.util")
local kset = _local_5_["kset"]
local bkset = _local_5_["bkset"]
local function insert_header()
  local s = vim.api.nvim_get_current_line()
  local with_head_3f = string.find(s, "^#.*")
  local final_line
  local function _6_()
    if with_head_3f then
      return "#"
    else
      return "# "
    end
  end
  final_line = (_6_() .. s)
  return vim.api.nvim_set_current_line(final_line)
end
local function remove_header()
  local s = vim.api.nvim_get_current_line()
  local with_head_3f = string.find(s, "^#.*")
  local with_heads_3f = string.find(s, "^##.*")
  local final_line
  local function _7_()
    if with_heads_3f then
      return 2
    elseif with_head_3f then
      return 3
    else
      return 0
    end
  end
  final_line = string.sub(s, _7_())
  return vim.api.nvim_set_current_line(final_line)
end
local function toggle_task_line(s)
  local selection = string.match(s, "^- %[(.)%]")
  if (" " == selection) then
    return s:gsub("^- %[.%]", "- %[X%]")
  elseif ("X" == selection) then
    return s:gsub("^- %[.%]", "- %[ %]")
  elseif (s:sub(1, 1) == "-") then
    return s:gsub("^- ", "- %[ %] ")
  else
    return ("- [ ] " .. s)
  end
end
local function toggle_task()
  local s = toggle_task_line(vim.api.nvim_get_current_line())
  return vim.api.nvim_set_current_line(s)
end
local function toggle_task_selection()
  local start = (first(vim.api.nvim_buf_get_mark(0, "<")) - 1)
  local _end = first(vim.api.nvim_buf_get_mark(0, ">"))
  local new_lines = map(toggle_task_line, vim.api.nvim_buf_get_lines(0, start, _end, 0))
  return vim.api.nvim_buf_set_lines(0, start, _end, 1, new_lines)
end
vim.api.nvim_create_user_command("MarkdownTaskToggleSelection", toggle_task_selection, {nargs = "*", desc = "Toggle taks in markdown selection"})
local function setup_quote()
  vim.cmd("call textobj#quote#init({'educate':0})")
  return toggle("q", "auto quotes", ":ToggleEducate<Cr>", 0)
end
local function setup_pensil()
  return bkset("x", "=", "gq")
end
local function setup_md()
  vim.cmd("set wrap linebreak nolist")
  bkset("x", "=", "gq")
  kset("n", "<Leader>ef", "vic:ToggleTermSendVisualSelection<cr>", {noremap = false})
  vim.keymap.set("n", "=", insert_header, {buffer = true})
  vim.keymap.set("n", "+", remove_header, {buffer = true})
  vim.keymap.set("n", "-", toggle_task)
  bkset("x", "-", "<Esc>:MarkdownTaskToggleSelection<cr>")
  bkset("n", "j", "v:count ? 'j' : 'gj'", {expr = true})
  bkset("n", "k", "v:count ? 'k' : 'gk'", {expr = true})
  bkset("n", "<space>h", "g0", {remap = false})
  bkset("n", "<space>l", "g$", {remap = false})
  bkset("n", "<D-k>", "viw\"9di[<C-r>9](<C-r>*)<Esc>")
  bkset("x", "<D-k>", "<Esc>`>a](<C-r>*)<C-o>`<[<Esc>")
  bkset("n", "<space>N", "vaw\"9di[<C-r>9]: <C-r>*<Esc>F[yi[")
  bkset("x", "<space>N", "<Esc>`>a]: <C-r>*<C-o>`<[<Esc>yi[")
  bkset("n", "<space>L", "caw[]<Esc>hpla[]<Esc>i")
  return bkset("x", "<space>L", "<Esc>`>a][<C-r>*]<C-o>`<[<Esc>")
end
vim.api.nvim_create_autocmd("BufWinEnter", {pattern = "*.md", group = vim.api.nvim_create_augroup("MarkdownSetup", {clear = true}), callback = setup_md})
return {}
