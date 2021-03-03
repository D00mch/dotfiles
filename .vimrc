set nocompatible

set relativenumber
set number
set autoindent
"set autochdir " change curernt working directory after changing buffer
set clipboard+=unnamedplus  "for osx
lang en_US.UTF-8
"set clipboard=unnamedplus
set encoding=utf-8

let mapleader=","
let maplocalleader=","

:syntax on
set background=dark
colorscheme PaperColor
au BufRead,BufNewFile *.lib set filetype=sh

"EDITING
    nnoremap U <C-r>
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
    let g:coc_node_path = '/usr/local/opt/node@15/bin/node'
    let g:airline#extensions#keymap#enabled = 0
"NAVIGATION
    " set current path
    nnoremap <leader>cd :cd %:p:h<CR>
    " to be able to search on files through path
    set path=$PWD/**  
    noremap <space>h ^
    noremap <space>l $
    "alt + q
    nnoremap œ :xa!<cr>

    "TABS
        nmap gh gT
        nmap gl gt
    "SPACEMACS-LIKE NAVIGATION COMMANDS
        set autowriteall
        noremap <space><tab> :e#<cr>
        "nnoremap <space>pt :NERDTreeFind<cr>
        noremap <space>pt :CocCommand explorer --sources=buffer+,file+<cr>
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
                \ { 'w': '~/work/todos.wiki' },
                \ '~/work/.aliases.',
                \ ]
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
        :packadd vim-iced-coc-source
    "SEXP
        nmap <space>ks <Plug>(sexp_capture_next_element)
        nmap <space>kS <Plug>(sexp_capture_prev_element)
        "alt + j
        nmap ∆ <Plug>(sexp_swap_list_forward)
        "alt + k
        nmap ˚ <Plug>(sexp_swap_list_backward)
        "alt + h
        nmap ˙ <Plug>(sexp_swap_element_backward)
        "alt + l
        nmap ¬ <Plug>(sexp_swap_element_forward)