set relativenumber
set number
set clipboard+=unnamed  "for osx
set nocompatible
set fileencoding=utf-8

let mapleader=","
let maplocalleader=","

set cursorline
set cursorcolumn

"EDITING
    "redo
    nmap U <C-r>

    "OBJECTS
        omap w iw
        omap W iW
        nnoremap dw daw
        nnoremap dW daW

    "COMMON
        "alt p - to paste in edit mode
        map! π <C-r>*
        "alt o - to remove word
        map! ø <C-w>
        "alt a - select all
        nmap å ggVG
        "alt o - to remove word
        nmap ø <C-o>
        "v to change visual
        vmap v  <C-v> 

    "PASTE
        "below - current line
        nmap cl mX"9yy"9p`Xj
        "below - empty line
        nmap <space>o o<Esc><Esc>

    "SAVING
        "alt + q
        nmap œ :silent! wa<bar>qa!<cr>

        "alt + s
        noremap ß :wa<CR>

    "COPY FILE, PATH
        nmap yp :let @+=expand("%:p")<cr>:echom expand("%:p")<cr>
        nmap yd :let @+=expand("%:p:h")<cr>:echom expand("%:p:h")<cr>
    "SPACEMACS-LIKE
        map <space>; gcc
        map <space>m q

"NAVIGATION
    " set current path
    nmap <leader>sd :cd %:p:h<CR>

    " to be able to search on files through path
    set path=$PWD/**
    noremap <space>h ^
    noremap <space>l g_

    "alt + w
    map ∑ <C-w>

    map <left> <C-u>
    map <right> <C-d>
    map <up> <C-y>
    map <down> <C-e>

    nmap <space><tab> :e#<cr>

    "TABS
        nmap gh gT
        nmap gl gt

    "SPACEMACS-LIKE COMMANDS
        noremap <space>bd :bd<cr>

    "SEARCH
        set ignorecase
        set incsearch
        set hlsearch

    "IDEA-LIKE COMMANDS
        " alt + b to fine this word in the project
        nmap ∫ :Rg <C-R><C-W><CR>

    "SEARCH
        nmap / /\v
        vnoremap / /\v

"SYNTAX
    "FOLDING
        function! MarkdownLevel()
            if getline(v:lnum) =~ '^# .*$'
                return ">1"
            endif
            if getline(v:lnum) =~ '^## .*$'
                return ">2"
            endif
            if getline(v:lnum) =~ '^### .*$'
                return ">3"
            endif
            if getline(v:lnum) =~ '^#### .*$'
                return ">4"
            endif
            if getline(v:lnum) =~ '^##### .*$'
                return ">5"
            endif
            if getline(v:lnum) =~ '^###### .*$'
                return ">6"
            endif
            return "="
        endfunction

        set fdm=syntax

        autocmd BufEnter *.md setlocal foldexpr=MarkdownLevel()
        autocmd BufEnter *.md setlocal foldmethod=expr
        autocmd Filetype vim set foldmethod=indent
        autocmd BufRead *.txt set foldmethod=indent

    "TABS
        nmap <tab> :noh<Enter>:echom ""<Enter>
        set smartindent
        set shiftwidth=4 smarttab expandtab
        set tags=./tags,tags;$HOME

"END
