set nocompatible

set relativenumber
set number
set autoindent
"set autochdir " change curernt working directory after changing buffer
set clipboard+=unnamed  "for osx
lang en_US.UTF-8
"set clipboard=unnamedplus
set encoding=utf-8

let mapleader=","
let maplocalleader=","

syntax on
set background=dark
colorscheme PaperColor
au BufRead,BufNewFile *.lib set filetype=sh

"EDITING
    nnoremap U <C-r>
    "alt + w
    inoremap ¬ <c-^>
    "restore last known position
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    "PERSISTENT UNDO
        set undofile
        set undodir=$HOME/.vim/undo
        set undolevels=1000
        set undoreload=10000
"PLUGINS SETUPS
    filetype plugin on
    filetype plugin indent on
    nnoremap <space>c :call Calc()<CR>     
    let g:airline#extensions#keymap#enabled = 0
"NAVIGATION
    " set current path
    nnoremap <leader>cd :cd %:p:h<CR>
    " to be able to search on files through path
    set path=$PWD/**  
    noremap <space>h ^
    noremap <space>l g_
    "alt + q
    nnoremap œ :xa!<cr>
    map <m-q> :xa!<cr>

    "TABS
        nmap gh gT
        nmap gl gt
    "SPACEMACS-LIKE NAVIGATION COMMANDS
        set autowriteall
        noremap <space><tab> :e#<cr>
        nnoremap <space>pt :NERDTreeFind<cr>
        noremap <space>bd :bd<cr>
        noremap <silent><space>pa :execute 'silent! update'<Bar>Ag<cr>
        noremap <silent><space>pf :execute 'silent! update'<Bar>FZF<cr>
        noremap <silent><space>bb :execute 'silent! update'<Bar>Buffers<cr>
    "SEARCH
        nnoremap / /\v
        vnoremap / /\v
        set ignorecase
        set incsearch
        set hlsearch
    "TER
        "alt + r
        tnoremap ® <C-\><C-n>
        "alt + t
        nnoremap † :Tnew<cr>gi
    "NEOTERM
        "alt + v, like in Idea
        vnoremap √ :<c-u>exec v:count.'TREPLSendSelection'<cr>   
    "SMART WAY TO MOVE BETWEEN WINDOWS
        "alt + j
        nmap ∆ <C-W>j
        "alt + k
        nmap ˚ <C-W>k
        "alt + h
        nmap ˙ <C-W>h
        "alt + l
        nmap ¬ <C-W>l 

        "alt + w
        nmap ∑ <C-W>
"SYNTAX
    "INDENTS
        set fdm=syntax
        autocmd Filetype vim set fdm=indent
        autocmd BufRead *.txt set fdm=indent
    "TABS
        set omnifunc=syntaxcomplete#Complete
        "autoclose
        autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif 
        nmap <tab> :noh<Enter>:echom ""<Enter>

        set smartindent
        set shiftwidth=4 smarttab expandtab
        
        set path+=**
        set tags=./tags,tags;$HOME

        let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
    "LANG
        "set spellfile=~/.vim/spell/{language}.{encoding}.add
        nnoremap <silent> <leader>se :setlocal spell! spelllang=en<cr>
        nnoremap <silent> <leader>sr :setlocal spell! spelllang=ru<cr>
        "RUSSIAN MAPPING
            set keymap=russian-jcukenmac
            set iminsert=0
            set imsearch=0
            highlight lCursor guifg=NONE guibg=Cyan
            
            inoremap <c-l> <c-^>
            "alt + l
            inoremap ¬ <c-^>
    "VIM-WIKI
        let g:vimwiki_list = [{'path':'~/Yandex.Disk.localized/notes/wiki', 'path_html':'~/Yandex.Disk.localized/notes/export/xml'}]
        let g:vimwiki_folding='syntax'
        let g:vimwiki_table_mappings=0
    "MULTILINES 
        " noremap  <buffer> <silent> k gk
        " noremap  <buffer> <silent> j gj
        " noremap  <buffer> <silent> 0 g0
        " noremap  <buffer> <silent> $ g$ 
"CLOJURE 
    "SEXP
        nmap <space>ks <Plug>(sexp_capture_next_element)
        nmap <space>kS <Plug>(sexp_capture_prev_element)
        map <C-j> <Plug>(sexp_swap_list_forward)
        map <C-k> <Plug>(sexp_swap_list_backward)
        map <C-h> <Plug>(sexp_swap_element_backward)
        map <C-l> <Plug>(sexp_swap_element_forward)
