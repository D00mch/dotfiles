set nocompatible
set backspace=indent,eol,start
set relativenumber
set number
set autoindent
"set autochdir " change curernt working directory after changing buffer
" set clipboard+=unnamed  "for osx
set clipboard=unnamedplus
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

"{{{ slime 
"alt + r
xmap ® <Plug>SlimeRegionSend
nmap ® <Plug>SlimeParagraphSend
"}}}

"{{{ tslime
let g:tslime_ensure_trailing_newlines = 1
let g:tslime_normal_mapping = '<localleader>t'
let g:tslime_visual_mapping = '<localleader>t'
let g:tslime_vars_mapping = '<localleader>T'
"}}}

vnoremap <silent> <Leader>t :<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>

"inoremap <leader>t <Esc>vip:<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>
"vnoremap <leader>t :<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>
"nnoremap <leader>t vip:<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>
" }}}

"{{{ spelling
"set spellfile=~/.vim/spell/{language}.{encoding}.add
nnoremap <silent> <leader>se :setlocal spell! spelllang=en<cr>
nnoremap <silent> <leader>sr :setlocal spell! spelllang=ru<cr>
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

"{{{ editing
nnoremap <space>o o<Esc>
"}}}

"{{{ search, replace, regex 
nnoremap / /\v
vnoremap / /\v

"WORKING WITH CODE 

"{{{ fireplace
"alt + d - check docs 
nnoremap ∂ K
"}}}

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

"{{{ to color parentheses | :RainbowToggle
let g:rainbow_active = 0
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'vim': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\		},
\		'html': {
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'css': 0,
\	}
\}


"{{{ emacs-like commands

"close/exit with <C-g>
map! <C-g> <Esc>
xmap <C-g> <Esc>
"}}}