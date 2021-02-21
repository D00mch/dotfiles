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
let maplocalleader=","

let g:airline#extensions#keymap#enabled = 0

" set current path
nnoremap <leader>cd :cd %:p:h<CR>

"{{{ clojure-highlight  
" Evaluate Clojure buffers on load     
" Without this coc-vim-iced will throw an error
autocmd BufRead *.clj try | silent! Require | catch /^Fireplace/ | endtry
"}}}
"

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

"{{{ spacemacs-like syntax
nnoremap <space><tab> :e#<cr>
nnoremap <space>pt :NERDTreeFind<cr>
nnoremap <space>bd :bd<cr>
nnoremap <space>pf :FZF<cr>
nnoremap <space>pa :Ag<cr>
nnoremap <space>bb :ls<cr>

nnoremap <space>c :call Calc()<CR> 
"}}}

"{{{ syntax
:syntax on
set background=dark
colorscheme xoria256

:command FormatJson %!python -c "import json, sys, collections; print json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), ensure_ascii=False, indent=4)"

au BufRead,BufNewFile *.lib set filetype=sh
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
"}}}

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

"{{{ vim-iced
let g:iced_enable_default_key_mappings = v:true

nmap <Nop>(iced_command_palette) <Plug>(iced_command_palette)
nmap <Leader>hc <Plug>(iced_command_palette)
nmap <Leader>hh <Plug>(iced_clojuredocs_open)

nmap <space>e <Plug>(iced_eval_and_print)af

let g:iced#buffer#stdout#mods = 'rightbelow' 
"}}}

"{{{ neoterm
"alt + v, like in Idea
vnoremap √ :<c-u>exec v:count.'TREPLSendSelection'<cr>  
"}}}
