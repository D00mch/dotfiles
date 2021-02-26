set nocompatible

set relativenumber
set number
set autoindent
"set autochdir " change curernt working directory after changing buffer
set clipboard+=unnamedplus  "for osx
lang en_US.UTF-8
"set clipboard=unnamedplus
set encoding=utf-8
set fdm=syntax
autocmd Filetype vim set fdm=indent
autocmd BufRead *.txt set fdm=indent

let mapleader=","
let maplocalleader=","

let g:airline#extensions#keymap#enabled = 0

:syntax on
set background=dark
colorscheme PaperColor
au BufRead,BufNewFile *.lib set filetype=sh

let g:coc_node_path = '/usr/local/opt/node@15/bin/node'

"PERSISTENT UNDO
    set undofile
    set undodir=$HOME/.vim/undo
    set undolevels=1000
    set undoreload=10000
"MANAGE PLUGINS
    filetype plugin on
    filetype plugin indent on
"NAVIGATION
    " set current path
    nnoremap <leader>cd :cd %:p:h<CR>
    " to be able to search on files through path
    set path=$PWD/**  

    "TABS
        nmap gh gT
        nmap gl gt
    
    "SPACEMACS-LIKE NAVIGATION COMMANDS
        set autowrite
        nnoremap <space><tab> :e#<cr>
        "nnoremap <space>pt :NERDTreeFind<cr>
        nnoremap <space>pt :CocCommand explorer<cr>
        nnoremap <space>bd :bd<cr>
        nnoremap <space>pf :FZF<cr>
        nnoremap <space>pa :Ag<cr>
        nnoremap <space>bb :ls<cr>
        
        nnoremap <space>c :call Calc()<CR>     
    "SEARCH
        nnoremap / /\v
        vnoremap / /\v
        set ignorecase
        set incsearch
        set hlsearch
        ":hi Search guibg=Yellow guifg=Black ctermbg=Yellow ctermfg=Black
    "TER
        tnoremap <Esc> <C-\><C-n>
    "NEOTERM
        "alt + v, like in Idea
        vnoremap √ :<c-u>exec v:count.'TREPLSendSelection'<cr>   
    "SMART WAY TO MOVE BETWEEN WINDOWS
        map <C-j> <C-W>j
        map <C-k> <C-W>k
        map <C-h> <C-W>h
        map <C-l> <C-W>l
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
        \ { 'type': 'files',     'header': ['   Files']            },
        \ { 'type': 'dir',       'header': ['   Dir '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]
    let g:startify_bookmarks = [
                \ { 'e': '~/.zshenv' },
                \ { 'v': '~/.vimrc' },
                \ { 'z': '~/.zshrc' },
                \ '~/work/todos.org',
                \ ]
"SYNTAX
    "TABS
        set omnifunc=syntaxcomplete#Complete
        "autoclose
        autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif 
        nmap <tab> :noh<Enter>:echom ""<Enter>

        set smartindent
        set shiftwidth=4 smarttab expandtab
        
        set path+=**
        set tags=./tags,tags;$HOME
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
    "VIM-ICED
        let g:iced_enable_default_key_mappings = v:true

        nmap <Nop>(iced_command_palette) <Plug>(iced_command_palette)
        nmap <Leader>hc <Plug>(iced_command_palette)
        nmap <Leader>hh <Plug>(iced_clojuredocs_open)
        
        nmap <space>e <Plug>(iced_eval_and_print)af
        nmap <Leader>ef <Plug>(iced_eval_outer_top_list)
        nmap <Leader>rfu <Plug>(iced_use_case_open)
        nmap <Leader>= <Plug>(iced_format_all)
        
        let g:iced#buffer#stdout#mods = 'rightbelow' 
        let g:iced_formatter = 'joker'


    "SEXP
        nmap <space>ks <Plug>(sexp_capture_next_element)
        nmap <space>kS <Plug>(sexp_capture_prev_element)

