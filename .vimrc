set relativenumber
set number
set clipboard+=unnamed  "for osx
set nocompatible
set fileencoding=utf-8

let mapleader=","
let maplocalleader=","

set cursorline
set cursorcolumn

"PLUGINS
    "INSTALLATION
        let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
        if empty(glob(data_dir . '/autoload/plug.vim'))
          silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
          autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif

        call plug#begin()

        "LuaLine
        Plug 'nvim-lualine/lualine.nvim'
        Plug 'kyazdani42/nvim-web-devicons'

        "tree
        Plug 'preservim/nerdtree'
        Plug 'ryanoasis/vim-devicons'

        Plug 'https://github.com/ervandew/supertab.git'
        Plug 'https://github.com/tpope/vim-commentary.git'
        Plug 'https://github.com/jpalardy/vim-slime.git'
        Plug 'mhinz/vim-startify'
        Plug 'https://github.com/tpope/vim-fugitive.git'
        Plug 'https://github.com/vim-scripts/ReplaceWithRegister.git'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        Plug 'https://github.com/jiangmiao/auto-pairs'
        Plug 'https://github.com/mbbill/undotree'

        "WIKI
        Plug 'https://github.com/xolox/vim-misc'
        Plug 'vimwiki/vimwiki'
        Plug 'sheerun/vim-polyglot'

        "CLOJURE
        Plug 'https://github.com/guns/vim-sexp.git'

        " Plug 'liquidz/vim-iced',                      { 'for': 'clojure' }
        " Plug 'prabirshrestha/asyncomplete.vim',       { 'for': 'clojure' }
        " Plug 'liquidz/vim-iced-asyncomplete',         { 'for': 'clojure' }
        Plug 'https://github.com/tpope/vim-surround'
        Plug 'junegunn/rainbow_parentheses.vim'
        Plug 'dense-analysis/ale'
        Plug 'Olical/conjure'
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

        "THEME
        Plug 'sainnhe/everforest'
        Plug 'arzg/vim-colors-xcode' 
        Plug 'cormacrelf/vim-colors-github'
        Plug 'sainnhe/sonokai'

        "Fennel
        Plug 'Olical/aniseed'

        call plug#end()

"EDITING
    "redo
    nmap U <C-r>

    "PASTE BELOW
        "current line
        nmap cl mX"9yy"9p`Xj
        "empty line
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

"NAVIGATION
    " set current path
    nmap <leader>sd :cd %:p:h<CR>

    " to be able to search on files through path
    set path=$PWD/**
    noremap <space>h ^
    noremap <space>l g_
    "alt + w
    nmap ∑ <C-W>

    nmap <space><tab> :e#<cr>

    "TABS
        nmap gh gT
        nmap gl gt

    "SPACEMACS-LIKE COMMANDS
        noremap <space>bd :bd<cr>
        noremap <silent><space>pa :execute 'silent! update'<Bar>Rg<cr>
        noremap <silent><space>pf :execute 'silent! update'<Bar>FZF<cr>
        noremap <silent><space>bb :execute 'silent! update'<Bar>Buffers<cr>

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
