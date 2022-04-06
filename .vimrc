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


"END
