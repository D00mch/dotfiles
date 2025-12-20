-- [nfnl] fnl/config/util.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local nvim = autoload("nvim")
local _local_2_ = autoload("nfnl.core")
local assoc = _local_2_.assoc
local update = _local_2_.update
local dec = _local_2_.dec
local inc = _local_2_.inc
local first = _local_2_.first
local second = _local_2_.second
local function println(message)
  return vim.api.nvim_echo({{message, "Normal"}}, true, {})
end
local function exists_3f(path)
  return (nvim.fn.filereadable(path) == 1)
end
local function lua_file(path)
  return nvim.ex.luafile(path)
end
local config_path = nvim.fn.stdpath("config")
local function _2bdocs(opts, to)
  local function _3_(desc)
    if (type(to) == "function") then
      return desc
    elseif (desc == nil) then
      return to
    else
      return (desc .. " " .. to)
    end
  end
  return update(opts, "desc", _3_)
end
local function _2bbuffer(opts, buffer)
  local function _5_(b)
    return (b or buffer)
  end
  return update(opts, "buffer", _5_)
end
local function kset(modes, from, to, opts)
  local opts0
  if (type(opts) == "table") then
    opts0 = opts
  elseif (type(opts) == "string") then
    opts0 = {desc = opts}
  else
    opts0 = nil
  end
  return vim.keymap.set(modes, from, to, _2bdocs(opts0, to))
end
local function kdel(modes, from, opts)
  return vim.keymap.del(modes, from, opts)
end
local function bkset(modes, from, to, opts)
  local opts0
  if (type(opts) == "table") then
    opts0 = _2bbuffer(opts, 0)
  elseif (type(opts) == "number") then
    opts0 = {buffer = opts}
  elseif (type(opts) == "string") then
    opts0 = _2bbuffer({desc = opts})
  else
    opts0 = {buffer = 0}
  end
  return vim.keymap.set(modes, from, to, _2bdocs(opts0, to))
end
local function bkdel(modes, from, b)
  return vim.keymap.del(modes, from, {buffer = (b or 0)})
end
local function vis_op(op, args)
  local function _8_()
    return op({vim.fn.line("."), vim.fn.line("v")}, args)
  end
  return _8_
end
local function vis_op_2b(op, args)
  local function _9_()
    return op({vim.api.nvim_buf_get_mark(0, "<"), vim.api.nvim_buf_get_mark(0, ">")}, args)
  end
  return _9_
end
local function get_word_under_cursor()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row = dec(first(cursor_pos))
  local col = second(cursor_pos)
  local line = first(vim.api.nvim_buf_get_lines(0, row, (row + 1), false))
  local left_part = line:sub(1, inc(col)):match("[%w_-]*$")
  local right_part = line:sub((col + 2)):match("^[%w_-]*")
  local word = (left_part .. right_part)
  return {word, row, col}
end
local function get_word_under_selection()
  local _let_10_ = vim.api.nvim_buf_get_mark(0, "<")
  local sr = _let_10_[1]
  local sc = _let_10_[2]
  local sr0,sc0 = dec(sr), sc
  local _let_11_ = vim.api.nvim_buf_get_mark(0, ">")
  local er = _let_11_[1]
  local ec = _let_11_[2]
  local er0,ec0 = dec(er), inc(ec)
  local _let_12_ = vim.api.nvim_buf_get_text(0, sr0, sc0, er0, ec0, {})
  local word = _let_12_[1]
  return {word, sr0, sc0, er0, ec0}
end
local _local_13_ = autoload("telescope.builtin")
local lsp_references = _local_13_.lsp_references
local lsp_implementations = _local_13_.lsp_implementations
local lsp_definitions = _local_13_.lsp_definitions
local function on_attach(_, b)
  local function _14_()
    return vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}), {0})
  end
  bkset("n", "<space>th", _14_, {buffer = b, desc = "Inlay hints"})
  local function _15_()
    vim.lsp.buf.hover()
    return vim.lsp.buf.hover()
  end
  bkset("n", "<leader>h", _15_, {buffer = b, desc = "Show docs"})
  local function _16_()
    return lsp_definitions({initial_mode = "normal"})
  end
  bkset("n", "gd", _16_, {buffer = b, desc = "Go definition"})
  bkset("n", "gD", "<c-w><c-]><c-w>T", {buffer = b, desc = "Go definition new tab"})
  bkset("n", "<leader>tD", vim.lsp.buf.type_definition, {buffer = b, desc = "Type definition"})
  bkset({"i", "n"}, "<M-;>", vim.lsp.buf.signature_help, {buffer = b, desc = "Signiture help"})
  bkset({"i", "n"}, "<D-p>", vim.lsp.buf.signature_help, {buffer = b, desc = "Signiture help"})
  bkset("n", "<leader>rr", vim.lsp.buf.rename, {buffer = b, desc = "Rename"})
  bkset("n", "<leader>p", vim.diagnostic.open_float, {buffer = b, desc = "Preview diagnostics"})
  if not string.find(vim.api.nvim_buf_get_name(b), ".*.fnl$") then
    bkset("n", "=", ":lua vim.lsp.buf.format({async = true})<Cr>", {buffer = b, desc = "Apply formatting"})
    bkset("x", "=", vis_op_2b(vim.lsp.buf.format, {async = true}), {buffer = b, desc = "Apply formatting"})
  else
  end
  bkset("n", "[s", vim.diagnostic.goto_prev, {buffer = b, desc = "Goto prev erro"})
  bkset("n", "]s", vim.diagnostic.goto_next, {buffer = b, desc = "Goto next erro"})
  local function _18_()
    return lsp_references({jump_type = "never"})
  end
  bkset("n", "<leader>gr", _18_, {buffer = b, desc = "Go to references"})
  bkset("n", "<leader>gi", lsp_implementations, {buffer = b, desc = "Go to implementations"})
  bkset({"i", "n", "x"}, "<C-r>", vim.lsp.buf.code_action, {buffer = b, desc = "Code actions"})
  return bkset({"n", "x"}, "<leader>ra", vim.lsp.buf.code_action, {buffer = b, desc = "Code actions"})
end
return {["config-path"] = config_path, ["lua-file"] = lua_file, println = println, ["exists?"] = exists_3f, kset = kset, bkset = bkset, bkdel = bkdel, ["vis-op"] = vis_op, ["vis-op+"] = vis_op_2b, ["get-word-under-cursor"] = get_word_under_cursor, ["get-word-under-selection"] = get_word_under_selection, ["on-attach"] = on_attach}
