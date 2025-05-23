-- [nfnl] fnl/config/init.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
require("config.which")
require("config.markdown")
require("config.misc")
vim.api.nvim_command("command! -nargs=1 -complete=help H help <args> | silent only")
local function _3_()
  local bd = require("bufdelete")
  return bd.bufdelete(0, true)
end
kset("n", "<Space>d", _3_)
do
  kset("x", "<D-c>", "y")
  kset({"n", "x"}, "<D-v>", "p")
  kset("t", "<D-v>", "<Esc>pa")
  kset({"i", "c"}, "<D-v>", "<C-r><C-o>*")
  kset("n", "<D-s>", ":w<Cr>")
  kset("x", "<D-s>", "<Esc>:w<Cr>gv")
  kset("i", "<D-s>", "<Esc>:w<Cr>a")
  kset("n", "<D-a>", "ggVG")
  kset("x", "<D-a>", "<Esc>ggVG")
  kset("i", "<D-a>", "<Esc><D-a>", {remap = true})
  kset("c", "<D-a>", "<C-f><Esc><D-a>", {remap = true})
  local function close_or_buffer_delete()
    if not pcall(vim.cmd, "close") then
      return vim.cmd("Bd")
    else
      return nil
    end
  end
  kset({"n", "x"}, "<D-w>", close_or_buffer_delete, {desc = "Close or :bd"})
  kset("i", "<D-w>", "<Esc><D-w>", {remap = true})
  kset("c", "<D-w>", "<Esc><Esc>")
  kset("n", "<D-z>", "u")
  kset("x", "<D-z>", "<Esc>ugv")
  kset("i", "<D-z>", "<Esc><D-z>a", {remap = true})
  kset("i", "<D-_>", "<C-k>-M")
  kset({"i", "c"}, "<D-->", "\226\128\148")
  kset({"n", "x"}, "<D-f>", "/")
  kset({"i", "t"}, "<D-f>", "<Esc><D-f>", {remap = true})
end
local function _5_()
  return vim.cmd("if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif")
end
vim.api.nvim_create_autocmd("BufReadPost", {pattern = "*", group = vim.api.nvim_create_augroup("LastPosition", {clear = true}), callback = _5_})
vim.o.autoread = true
nvim.o.mouse = "a"
local function compare_to_clipboard()
  local ftype = vim.api.nvim_eval("&filetype")
  return vim.cmd(string.format("execute 'normal! \"xy'\n      tabnew\n      vsplit\n      enew\n      normal! P\n      setlocal buftype=nowrite\n      set filetype=%s\n      diffthis\n      execute \"normal! \\<C-w>\\<C-w>\"\n      enew\n      set filetype=%s\n      normal! \"xP\n      diffthis", ftype, ftype))
end
kset({"x"}, "<Space>cc", compare_to_clipboard, {desc = "Clipboard Compare"})
local function _6_()
  return vim.highlight.on_yank({higroup = "IncSearch", timeout = 300})
end
vim.api.nvim_create_autocmd("TextYankPost", {group = vim.api.nvim_create_augroup("yank_highlight", {}), pattern = "*", callback = _6_})
kset("n", "<Leader>dm", ":let @*=trim(execute('messages'))<bar>echo 'copied' <cr>")
return {}
