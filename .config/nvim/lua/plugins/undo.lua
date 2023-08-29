-- [nfnl] Compiled from fnl/plugins/undo.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_["kset"]
local function _3_()
  nvim.ex.set("undofile")
  nvim.o.undodir = (nvim.fn.stdpath("data") .. "/undo")
  nvim.o.undolevels = 1000
  nvim.o.undoreload = 10000
  kset("n", "<Space>ut", ":UndotreeShow<cr>:UndotreeFocus<cr>", {silent = true})
  return vim.cmd("function g:Undotree_CustomMap()\n                   nmap <buffer> <D-w> q\n                   map <buffer> d D\n                   endfunction")
end
return {{"mbbill/undotree", init = _3_}}
