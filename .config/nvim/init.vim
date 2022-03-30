set runtimepath^=~/.vim
let &packpath=&runtimepath
source ~/.vimrc

au TextYankPost * silent! lua vim.highlight.on_yank()
