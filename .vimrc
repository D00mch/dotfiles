set nocompatible
set backspace=indent,eol,start
set relativenumber
set number
set autoindent
"set autochdir " change curernt working directory after changing buffer
set clipboard+=unnamed  "for osx
"set clipboard=unnamedplus
set encoding=utf-8

let mapleader=","

let g:airline#extensions#keymap#enabled = 0

"{{{ clojure-highlight
" Evaluate Clojure buffers on load
autocmd BufRead *.clj try | silent! Require | catch /^Fireplace/ | endtry
"}}}

"{{{ russian mapping
set keymap=russian-jcukenmac
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

inoremap <c-l> <c-^>
"}}}

" manage plugins
filetype plugin on
filetype plugin indent on

" vim-notes
:let g:notes_directories = ['~/Yandex.Disk.localized/notes/vim']
" vim-wiki
let g:vimwiki_list = [{'path':'~/Yandex.Disk.localized/notes/wiki', 'path_html':'~/Yandex.Disk.localized/notes/export/xml'}]
let g:vimwiki_folding='syntax'

"{{{ spelling
"set spellfile=~/.vim/spell/{language}.{encoding}.add
nnoremap <silent> <leader>se :setlocal spell! spelllang=en<cr>
nnoremap <silent> <leader>sr :setlocal spell! spelllang=ru<cr>
"}}}

"{{{ emacs-like syntax
nnoremap <space><tab> :e#<cr>
nnoremap <space>pt :NERDTree<cr>
"}}}

"{{{ syntax
:syntax on
set background=dark
colorscheme xoria256

:command FormatJson %!python -c "import json, sys, collections; print json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), ensure_ascii=False, indent=4)"

au BufRead,BufNewFile *.lib set filetype=sh

set guifont=Monospace\ 14 "default font for gVim 
"}}}

set nocompatible

"{{{ search
set ignorecase
set incsearch
set hlsearch
:hi Search guibg=Yellow guifg=Black ctermbg=Yellow ctermfg=Black
"}}}

set smartindent
set shiftwidth=4 smarttab expandtab

set path+=**
set tags=./tags,tags;$HOME

"completion

"{{{Tab.
set omnifunc=syntaxcomplete#Complete
"autoclose
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif 

nmap <tab> :noh<Enter>:echom ""<Enter>
"}}}
"{{{Tabs
nmap gh gT
nmap gl gt
"}}}

noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

"alt + a  -> select all
nnoremap å ggVG

"{{{ search, replace, regex 
nnoremap / /\v
vnoremap / /\v

"WORKING WITH CODE 

"{{{ configure clojure folding
set foldmethod=syntax
let g:clojure_foldwords = "def,defn,defmacro,defmethod,defschema,defprotocol,defrecord"
"}}}

"{{{ syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"}}}

set path=$PWD/**  " to be able to search on files through path
