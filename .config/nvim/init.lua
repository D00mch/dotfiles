vim.g.mapleader = ","
vim.g.maplocalleader= ","

vim.cmd([[
set runtimepath^=~/.vim
let &packpath=&runtimepath
source ~/.vimrc
au TextYankPost * silent! lua vim.highlight.on_yank()
]])

require('aniseed.env').init()

