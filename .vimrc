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
    nnoremap U <C-r>

    "OBJECTS
        onoremap w iw
        onoremap W iW
        nnoremap dw daw
        nnoremap dW daW

    "COMMON
        "alt p - to paste in edit mode
        noremap! π <C-r>*
        "alt o - to remove word
        noremap! ø <C-w>
        "alt a - select all
        nnoremap å ggVG
        "alt o - to remove word
        nnoremap ø <C-o>
        "v to change visual
        vmap v  <C-v> 

    "PASTE
        "below - current line
        nnoremap cl mX"9yy"9p`Xj
        "below - empty line
        nnoremap <space>o o<Esc><Esc>

    "SAVING
        "alt + q
        nnoremap œ :silent! wa<bar>qa!<cr>

        "alt + s
        noremap ß :wa<CR>

    "COPY FILE, PATH
        nnoremap yp :let @+=expand("%:p")<cr>:echom expand("%:p")<cr>
        nnoremap yd :let @+=expand("%:p:h")<cr>:echom expand("%:p:h")<cr>
    "SPACEMACS-LIKE
        map <space>; gcc
        nnoremap <space>q q

"NAVIGATION
    " set current path
    nnoremap <leader>sd :cd %:p:h<CR>

    " to be able to search on files through path
    set path=$PWD/**
    noremap <space>h ^
    noremap <space>l g_

    noremap <left> <C-u>
    noremap <right> <C-d>
    noremap <up> <C-y>
    noremap <down> <C-e>

    nnoremap <space><tab> :e#<cr>

    "WINDOWS
        "alt + w
        noremap ∑ <C-w>
        map gh <C-w>h
        map gl <C-w>l
        map gj <C-w>j
        map gk <C-w>k

    "SPACEMACS-LIKE COMMANDS
        noremap <space>bd :bd<cr>

    "SEARCH
        set ignorecase
        set incsearch
        set hlsearch

    "IDEA-LIKE COMMANDS
        " alt + b to fine this word in the project
        nnoremap ∫ :Rg <C-R><C-W><CR>

    "SEARCH
        " nnoremap / /\v
        " vnoremap / /\v

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
        nnoremap <tab> :noh<Enter>:echom ""<Enter>
        set smartindent
        set shiftwidth=4 smarttab expandtab
        set tags=./tags,tags;$HOME

"END
