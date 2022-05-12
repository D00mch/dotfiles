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
    noremap <space>h ^
    noremap <space>l g_

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
        imap œ <Esc>œ

        "alt + s
        noremap ß :w<CR>
        inoremap ß <Esc>:w<CR>a


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

    noremap <left> 20<C-y>20k
    noremap <right> 20<C-e>20j
    noremap <up> 2<C-y>
    noremap <down> 2<C-e>

    nnoremap <silent> <space><tab> <cmd>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<cr>

    "WINDOWS
        "alt + w
        nnoremap ∑ <C-w>
        nnoremap gh <C-w>h
        nnoremap gl <C-w>l
        nnoremap gj <C-w>j
        nnoremap gk <C-w>k

        "RESIZE
        nnoremap g= <C-w>5+
        nnoremap g- <C-w>5-
        "alt+
        nnoremap ≠ <C-w>5>+
        nnoremap – <C-w>5<+

    "SPACEMACS-LIKE COMMANDS 
        noremap <space>bd :silent! bd!<cr>

    "SEARCH
        set ignorecase
        set incsearch
        set hlsearch

    "SEARCH
        " nnoremap / /\v
        " vnoremap / /\v

"SYNTAX
    "FOLDING
        "no foldings by default
        set nofen 
        autocmd Filetype vim set foldmethod=indent
        autocmd BufRead *.txt set foldmethod=indent

    "TABS
        nnoremap <tab> :noh<Enter>:echom ""<Enter>
        set smartindent
        set shiftwidth=4 smarttab expandtab
        set tags=./tags,tags;$HOME
    "WRAP
        " noremap <expr> j v:count ? 'j' : 'gj'
        " noremap <expr> k v:count ? 'k' : 'gk'
        " noremap <space>h g0
        " noremap <space>l g$
    "Markdown
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
        au BufEnter *.md setlocal foldexpr=MarkdownLevel()  
        au BufEnter *.md setlocal foldmethod=expr    
"END
