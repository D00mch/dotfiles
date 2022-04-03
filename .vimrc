set nocompatible

let mapleader=","
let maplocalleader=","

"PLUGINS
    "INSTALLATION
        let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
        if empty(glob(data_dir . '/autoload/plug.vim'))
          silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
          autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif

        call plug#begin()
        Plug 'vim-airline/vim-airline'
        Plug 'https://github.com/ervandew/supertab.git'
        Plug 'https://github.com/tpope/vim-commentary.git'
        Plug 'https://github.com/jpalardy/vim-slime.git'
        Plug 'preservim/nerdtree'
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
        Plug 'https://github.com/guns/vim-sexp.git',  { 'for': 'clojure' }
        Plug 'liquidz/vim-iced',                      { 'for': 'clojure' }
        Plug 'prabirshrestha/asyncomplete.vim',       { 'for': 'clojure' }
        Plug 'liquidz/vim-iced-asyncomplete',         { 'for': 'clojure' }
        Plug 'https://github.com/tpope/vim-surround'

        "THEME
        Plug 'sainnhe/everforest'
        Plug 'arzg/vim-colors-xcode' 
        Plug 'cormacrelf/vim-colors-github'

        call plug#end()

    "ALL
        filetype plugin on
        filetype plugin indent on
        nnoremap <space>c :call Calc()<CR>     
        let g:airline#extensions#keymap#enabled = 0

    "NERDTREE
        let g:NERDTreeHijackNetrw = 1
        au VimEnter NERD_tree_1 enew | execute 'NERDTree '.argv()[0]
        let NERDTreeShowHidden=1

    "STARTIFY
        "help functions
            function! s:gitModified()
                let files = systemlist('git ls-files -m 2>/dev/null')
                return map(files, "{'line': v:val, 'path': v:val}")
            endfunction

            function! s:gitUntracked()
                let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
                return map(files, "{'line': v:val, 'path': v:val}")
            endfunction

        let g:startify_change_to_vcs_root = 1
        let g:startify_lists = [
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ { 'type': 'files',     'header': ['   Files']            },
            \ { 'type': 'dir',       'header': ['   Dir '. getcwd()] },
            \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
            \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
            \ { 'type': 'commands',  'header': ['   Commands']       },
            \ ]
        let g:startify_bookmarks = [
                    \ { 'e': '~/dotfiles/.zshenv' },
                    \ { 'v': '~/dotfiles/.vimrc' },
                    \ { 'z': '~/dotfiles/.zshrc' },
                    \ { 'w': '~/wiki/todo.md' },
                    \ ]
        nmap <Leader>mp :Startify<cr>

    "VIM-WIKI
        let g:vimwiki_list = [{'path':   '~/Yandex.Disk.localized/notes/wiki',
                             \ 'syntax': 'markdown', 
                             \ 'ext':    '.md'}]
        let g:vimwiki_folding='custom'
        let g:vimwiki_table_mappings=0
        let g:vimwiki_global_ext = 0
        let g:vimwiki_map_prefix = '<Leader>n'
        au filetype vimwiki silent! unmap <buffer> <Tab>
        autocmd BufWinEnter *.md setlocal syntax=markdown
        autocmd BufEnter *.md colorscheme PaperColor

    "AUTOPAIRS
    au Filetype clojure let b:AutoPairs={'(':')', '[':']', '{':'}','"':'"', '`':'`'}

"THEME
    let output =  system("defaults read -g AppleInterfaceStyle")
    if v:shell_error == 0
        set background=dark
        colorscheme everforest
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
        nnoremap <space>pt :NERDTreeFind<cr>
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

        "SEXP
            nmap <space>ks <Plug>(sexp_capture_next_element)
            nmap <space>kS <Plug>(sexp_capture_prev_element)
            map <C-j> <Plug>(sexp_swap_list_forward)
            map <C-k> <Plug>(sexp_swap_list_backward)
            map <C-h> <Plug>(sexp_swap_element_backward)
            map <C-l> <Plug>(sexp_swap_element_forward)
            nmap <Leader>c <Plug>(sexp_move_to_prev_bracket)i#_<C-[>
        "VIM-ICED
            let g:iced_enable_default_key_mappings = v:false
            let g:iced#buffer#document#height = 25
            let g:iced#notify#max_width_rate=0.4
            let g:iced#notify#max_height_rate=0.4

            nmap <Nop>(iced_command_palette) <Plug>(iced_command_palette)

            "DOCS
            nmap <Leader>hh <Plug>(iced_clojuredocs_open)
            nmap <Leader>hq <Plug>(iced_document_close)

            "REFACTOR
            autocmd Filetype clojure nmap <Leader>= <Plug>(iced_format_all)
            autocmd Filetype clojure nmap <Leader>rfu <Plug>(iced_use_case_open)
            autocmd Filetype clojure nmap <Leader>ran <Plug>(iced_add_ns)
            autocmd Filetype clojure nmap <Leader>ram <Plug>(iced_add_missing)
            autocmd Filetype clojure nmap gd <Plug>(iced_def_jump)
            autocmd Filetype clojure nmap <space>kb <Plug>(iced_barf)
            autocmd Filetype clojure nmap <space>kB <Plug>(sexp_emit_head_element)
            autocmd Filetype clojure nmap <space>ks <Plug>(iced_slurp)
            autocmd Filetype clojure nmap <space>kS <Plug>(sexp_capture_prev_element)
            autocmd Filetype clojure nmap <Leader>rr <Plug>(iced_rename_symbol)
            autocmd Filetype clojure nmap <Leader>ra <Plug>(iced_command_palette)
            autocmd Filetype clojure nmap <Leader>rtf <Plug>(iced_thread_first)
            autocmd Filetype clojure nmap <Leader>rtl <Plug>(iced_thread_last)

            "REPL
            autocmd Filetype clojure nmap <Leader>' <Plug>(iced_connect)
            autocmd Filetype clojure nmap <Leader>" <Plug>(iced_jack_in)

            autocmd Filetype clojure nmap <space>e <Plug>(iced_eval_and_comment)af
            autocmd Filetype clojure nmap <Leader>sf <Plug>(iced_eval_and_print)af
            autocmd Filetype clojure nmap <Leader>ef <Plug>(iced_eval_outer_top_list)
            autocmd Filetype clojure nmap <Leader>sn <Plug>(iced_eval_ns)
            autocmd Filetype clojure nmap <Leader>eb ggVG<Plug>(iced_eval_visual)
            autocmd Filetype clojure nmap <Leader>ei <Plug>(iced_eval)<Plug>(sexp_inner_element)
            autocmd Filetype clojure nmap <Leader>si <Plug>(iced_eval_and_print)<Plug>(sexp_inner_element)
            autocmd Filetype clojure nmap <Leader>ee <Plug>(iced_eval)<Plug>(sexp_outer_list)
            autocmd Filetype clojure nmap <Leader>eu <Plug>(iced_undef)
            autocmd Filetype clojure nmap <Leader>eU <Plug>(iced_undef_all_in_ns)
            autocmd Filetype clojure nmap <Leader>eq <Plug>(iced_interrupt)
            autocmd Filetype clojure nmap <Leader>eQ <Plug>(iced_interrupt_all)
            autocmd Filetype clojure vmap <Leader>ev <Plug>(iced_eval_visual)

            "STDOUT BUFFER
            autocmd Filetype clojure nmap <Leader>ss <Plug>(iced_stdout_buffer_toggle)
            autocmd Filetype clojure nmap <Leader>so <Plug>(iced_stdout_buffer_open)
            autocmd Filetype clojure nmap <Leader>sc <Plug>(iced_stdout_buffer_clear)
            autocmd Filetype clojure nmap <Leader>sq <Plug>(iced_stdout_buffer_close)

            let g:iced#buffer#stdout#mods = 'rightbelow' 
            "let g:iced_formatter = 'joker'

"END
