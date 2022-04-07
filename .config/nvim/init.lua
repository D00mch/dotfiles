vim.g.mapleader = ","
vim.g.maplocalleader= ","

vim.cmd([[
set runtimepath^=~/.vim
let &packpath=&runtimepath
source ~/.vimrc
au TextYankPost * silent! lua vim.highlight.on_yank()

" Rg hidden
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
]])


require('aniseed.env').init()

