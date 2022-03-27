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

set cursorline
set cursorcolumn

"EDITING
    nnoremap U <C-r>
    "alt + w  to remove
    inoremap ¬ <c-w>
    "restore last known position
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    "PERSISTENT UNDO
        set undofile
        set undodir=$HOME/.vim/undo
        set undolevels=1000
        set undoreload=10000
    "COPY FILE, PATH
        nnoremap yp :let @+=expand("%:p")<cr>:echom expand("%:p")<cr>
        nnoremap yd :let @+=expand("%:p:h")<cr>:echom expand("%:p:h")<cr>
    "PASTE LINE BELOW
        nnoremap cl mX"9yy"9p`Xj

"PLUGINS SETUPS
    filetype plugin on
    filetype plugin indent on
    nnoremap <space>c :call Calc()<CR>     
    let g:airline#extensions#keymap#enabled = 0

    "FIREVIM
        if exists('g:started_by_firenvim')
            set bg=light
            colorscheme PaperColor

            "FONTSIZE AND AREA
            set guifont=CaskaydiaCove_Nerd_Font_Mono:h16
            " set guifont=FiraCode_Nerd_Font_Mono:h22

            let s:fontsize = 16
            function! AdjustFontSizeF(amount)
              let s:fontsize = s:fontsize+a:amount
              execute "set guifont=CaskaydiaCove_Nerd_Font_Mono:h" . s:fontsize
              call rpcnotify(0, 'Gui', 'WindowMaximized', 1)
            endfunction

            noremap  <C-=> :call AdjustFontSizeF(1)<CR>
            noremap  <C--> :call AdjustFontSizeF(-1)<CR>

            let s:lines = 10
            let s:columns = 70
            function! AdjustLines(amount)
              let s:lines = s:lines+a:amount
              let s:columns = s:columns+a:amount
              execute "set lines=" . s:lines . " columns=" . s:columns
            endfunction

            noremap  ≠ :call AdjustLines(1)<CR>
            noremap  – :call AdjustLines(-1)<CR>

            "SAVING BACKUPS
                let g:timer_started = v:false
                function! Write_Backup(timer) abort
                  let g:timer_started = v:false
                  write! /tmp/firenvim_backup.txt
                endfunction
                
                function! On_Text_Changed() abort
                  if g:timer_started
                    return
                  end
                  let g:timer_started = v:true
                  call timer_start(10000, 'Write_Backup')
                endfunction
                
                au TextChanged * ++nested call On_Text_Changed()
                au TextChangedI * ++nested call On_Text_Changed()

            "TAKEOVER
                let g:firenvim_config = { 
                    \ 'globalSettings': {
                        \ 'cmd': 'all',
                    \  },
                    \ 'localSettings': {
                        \ '.*': {
                            \ 'cmdline': 'neovim',
                            \ 'content': 'text',
                            \ 'priority': 0,
                            \ 'selector': 'textarea',
                            \ 'takeover': 'never',
                        \ },
                    \ }
                \ }

        endif
"NAVIGATION
    " set current path
    nnoremap <leader>cd :cd %:p:h<CR>
    " to be able to search on files through path
    set path=$PWD/**  
    noremap <space>h ^
    noremap <space>l g_

    "alt + q
    function! ShutUpAndClose()
      execute ":wa"
      execute ":qa!"
    endfunction
    nnoremap œ :call ShutUpAndClose()<CR>

    "alt + s
    noremap ß :wa<CR>

    "TABS
        nmap gh gT
        nmap gl gt
    "SPACEMACS-LIKE NAVIGATION COMMANDS
        set autowriteall
        noremap <space><tab> :e#<cr>
        " nnoremap <space>pt :NERDTreeFind<cr>
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
        "SLIME
            let g:slime_target = "neovim"
            xmap √ <Plug>SlimeRegionSend
            nmap <leader>ef <Plug>SlimeParagraphSend 
    "NEOTERM
        "alt + v, like in Idea
        "vnoremap √ :<c-u>exec v:count.'TREPLSendSelection'<cr>   
        "alt + t
        nnoremap † :Tnew<cr>gi
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

    "VIM-WIKI
        let g:vimwiki_list = [{'path':   '~/Yandex.Disk.localized/notes/wiki',
                             \ 'syntax': 'markdown', 
                             \ 'ext':    '.md'}]
        let g:vimwiki_folding='syntax'
        let g:vimwiki_table_mappings=0
        au filetype vimwiki silent! unmap <buffer> <Tab>
        autocmd BufWinEnter *.md setlocal syntax=markdown
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
"END
