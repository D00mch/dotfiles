set nocompatible

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
        Plug 'theniceboy/vim-calc'
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

    "ALL
        filetype plugin on
        filetype plugin indent on
        nnoremap <space>c :call Calc()<CR>     

        "rainbow activation based on file type
        augroup rainbow_lisp
          autocmd!
          autocmd FileType lisp,clojure,scheme,fennel RainbowParentheses
        augroup END

        " let g:conjure#client#fennel#aniseed#aniseed_module_prefix = "aniseed."

"THEME
    let output =  system("defaults read -g AppleInterfaceStyle")
    if v:shell_error == 0
        set background=dark
        let g:sonokai_style = 'espresso'
        colorscheme sonokai
        "colorscheme everforest
    else
        set background=light
        colorscheme github
    endif

"EDITING
    "ALL
        set encoding=utf-8
        set clipboard+=unnamed  "for osx
        set autoindent

        set relativenumber
        set number

        set cursorline
        set cursorcolumn

        nnoremap U <C-r>

    "SAVING
        "alt + q
        function! ShutUpAndClose()
          execute ":wa"
          execute ":qa!"
        endfunction
        "alt + q
        nnoremap œ :call ShutUpAndClose()<CR>
        "alt + s
        noremap ß :wa<CR>

    "PASTE BELOW
        "current line
        nnoremap cl mX"9yy"9p`Xj
        "empty line
        nnoremap <space>o o<Esc><Esc>

    "UNDO
        "restore last known position
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        "PERSISTENT
        set undofile
        set undodir=$HOME/.vim/undo
        set undolevels=1000
        set undoreload=10000

        "TREE
        map <space>au :UndotreeToggle<cr>
         
        "COPY FILE, PATH
        nnoremap yp :let @+=expand("%:p")<cr>:echom expand("%:p")<cr>
        nnoremap yd :let @+=expand("%:p:h")<cr>:echom expand("%:p:h")<cr>

    "SPACEMACS-LIKE
        map <space>; gcc

"NAVIGATION
    "All
        " set current path
        nnoremap <leader>sd :sd %:p:h<CR>

        " to be able to search on files through path
        set path=$PWD/**  
        noremap <space>h ^
        noremap <space>l g_

        nnoremap <space><tab> :e#<cr>

    "TABS
        nmap gh gT
        nmap gl gt

    "SPACEMACS-LIKE NAVIGATION COMMANDS
        noremap <space>bd :bd<cr>

    "SEARCH
        set ignorecase
        set incsearch
        set hlsearch

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

    "SPACEMACS-LIKE COMMANDS
        " nnoremap <space>pt :NERDTreeFind<cr>
        noremap <silent><space>pa :execute 'silent! update'<Bar>Rg<cr>
        noremap <silent><space>pf :execute 'silent! update'<Bar>FZF<cr>
        noremap <silent><space>bb :execute 'silent! update'<Bar>Buffers<cr>

    "IDEA-LIKE COMMANDS
        " alt + b to fine this word in the project
        nnoremap ∫ :Rg <C-R><C-W><CR>

    "SEARCH
        nnoremap / /\v
        vnoremap / /\v

    "TER
        "alt + r
        tnoremap ® <C-\><C-n>
        "SLIME
            let g:slime_target = "neovim"
            xmap √ <Plug>SlimeRegionSend
            nmap <leader>ef <Plug>SlimeParagraphSend 

"SYNTAX
    "ALL
        syntax on
        au BufRead,BufNewFile *.lib set filetype=sh

    "VIM
        autocmd Filetype vim nmap gd :help <C-R><C-W>\|on<CR> 

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
        set omnifunc=syntaxcomplete#Complete
        "autoclose
        autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif 
        set path+=**
        let g:SuperTabDefaultCompletionType = "<c-n>"

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
            "change to russian and go in insert mode
            nmap <silent> <space>r :set iminsert=1 imsearch=1<cr>
            nmap <silent> <space>e :set iminsert=0 imsearch=0<cr>

    "MULTILINES 
        " noremap  <buffer> <silent> k gk
        " noremap  <buffer> <silent> j gj
        " noremap  <buffer> <silent> 0 g0
        " noremap  <buffer> <silent> $ g$ 
 
    "CLOJURE 
        "ALL
            au! BufRead,BufNewFile *.cljd setfiletype clojure

"END
