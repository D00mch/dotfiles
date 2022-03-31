source ~/.vimrc_common

set autoindent
"set autochdir " change curernt working directory after changing buffer
lang en_US.UTF-8
set encoding=utf-8

syntax on
au BufRead,BufNewFile *.lib set filetype=sh

set cursorline
set cursorcolumn

"THEME
    let output =  system("defaults read -g AppleInterfaceStyle")
    if v:shell_error == 0
        set background=dark
        colorscheme everforest
    else
        set background=light
        colorscheme github
    endif

"PLUGINS
    "INSTALLATION
        let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
        if empty(glob(data_dir . '/autoload/plug.vim'))
          silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
          autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif

    filetype plugin on
    filetype plugin indent on
    nnoremap <space>c :call Calc()<CR>     
    let g:airline#extensions#keymap#enabled = 0

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

"EDITING
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
    "SPACEMACS-LIKE
        map <space>; gcc

"NAVIGATION
    "SPACEMACS-LIKE NAVIGATION COMMANDS
        nnoremap <space>pt :NERDTreeFind<cr>
        noremap <silent><space>pa :execute 'silent! update'<Bar>Ag<cr>
        noremap <silent><space>pf :execute 'silent! update'<Bar>FZF<cr>
        noremap <silent><space>bb :execute 'silent! update'<Bar>Buffers<cr>
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

"SYNTAX
    "TABS
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
            nmap <Leader>= <Plug>(iced_format_all)
            nmap <Leader>rfu <Plug>(iced_use_case_open)
            nmap <Leader>ran <Plug>(iced_add_ns)
            nmap <Leader>ram <Plug>(iced_add_missing)
            nmap gd <Plug>(iced_def_jump)
            nmap <space>kb <Plug>(iced_barf)
            nmap <space>kB <Plug>(sexp_emit_head_element)
            nmap <space>ks <Plug>(iced_slurp)
            nmap <space>kS <Plug>(sexp_capture_prev_element)
            nmap <Leader>rr <Plug>(iced_rename_symbol)
            nmap <Leader>ra <Plug>(iced_command_palette)
            nmap <Leader>rtf <Plug>(iced_thread_first)
            nmap <Leader>rtl <Plug>(iced_thread_last)
            " nmap <Leader>c <Plug>(sexp_outer_list)i#_

            "REPL
            nmap <Leader>' <Plug>(iced_connect)
            nmap <Leader>" <Plug>(iced_jack_in)
            nmap <space>e <Plug>(iced_eval_and_comment)af
            nmap <Leader>sf <Plug>(iced_eval_and_print)af
            nmap <Leader>ef <Plug>(iced_eval_outer_top_list)
            nmap <Leader>sn <Plug>(iced_eval_ns)
            nmap <Leader>eb ggVG<Plug>(iced_eval_visual)
            nmap <Leader>ei <Plug>(iced_eval)<Plug>(sexp_inner_element)
            nmap <Leader>si <Plug>(iced_eval_and_print)<Plug>(sexp_inner_element)
            nmap <Leader>ee <Plug>(iced_eval)<Plug>(sexp_outer_list)
            nmap <Leader>eu <Plug>(iced_undef)
            nmap <Leader>eU <Plug>(iced_undef_all_in_ns)
            nmap <Leader>eq <Plug>(iced_interrupt)
            nmap <Leader>eQ <Plug>(iced_interrupt_all)
            vmap <Leader>ev <Plug>(iced_eval_visual)

            "STDOUT BUFFER
            nmap <Leader>ss <Plug>(iced_stdout_buffer_toggle)
            nmap <Leader>so <Plug>(iced_stdout_buffer_open)
            nmap <Leader>sc <Plug>(iced_stdout_buffer_clear)
            nmap <Leader>sq <Plug>(iced_stdout_buffer_close)

            let g:iced#buffer#stdout#mods = 'rightbelow' 
            "let g:iced_formatter = 'joker'

"END
