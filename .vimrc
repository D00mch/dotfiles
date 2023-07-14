set relativenumber
set number
set clipboard+=unnamed  "for osx
set nocompatible
set fileencoding=utf-8

let mapleader=","
let maplocalleader=","

set cursorline
set cursorcolumn

cd $HOME

"EDITING
    "redo
    nnoremap U <C-r>
    " noremap <space>h ^
    " noremap <space>l g_
    noremap <home> ^
    noremap <end> g_
    nnoremap <Bs> <C-o>
    nmap \ gcc
    vmap \ gcc

    "INFO
        noremap <leader>z g<C-g>
        vnoremap <leader>z g<C-g>2gs

    "OBJECTS
        onoremap w iw
        onoremap W iW
        nnoremap vw viw
        nnoremap vW viW
        onoremap iq i"
        onoremap aq a"
        xnoremap iq i"
        xnoremap aq a"

    "COMMON
        "v to change visual
        vnoremap v <C-v>

    "PASTE
        "below - current line
        nnoremap cl mX"9yy"9p`Xj
        "below - paste from buffer
        nnoremap <space>o mXo<C-r><C-o>*<Esc><Esc>`X

    "SAVING
        nnoremap <M-q> :silent! wa<bar>qa!<cr>
        imap <M-q> <Esc>œ

    "COPY FILE, PATH
        nnoremap yp :let @+=expand("%:p")<cr>:echom expand("%:p")<cr>
        nnoremap yd :let @+=expand("%:p:h")<cr>:echom expand("%:p:h")<cr>
    "SPACEMACS-LIKE
        map <space>; gcc

        " Record in 'f' with <Space>q
        
        function! ToggleRecordingF()
            let mode = mode()

            if mode == 'n'
                " Not currently recording, so start recording
                normal! qf
            elseif mode == 'r'
                stoprecord
            endif
        endfunction
        nnoremap <space>q :call ToggleRecordingF()<Cr>
        nnoremap Q q
        nnoremap <space>f @f

        "remove unnecessary spaces at the end of lines
        nnoremap <space>as mX:%s/\s\s*$//g<cr>`X
        vnoremap <space>as :s/\s\s*$//g<cr>

    "INCLUTION
        nnoremap db vb

"NAVIGATION
    " set current path
    nnoremap <space>sd :cd %:p:h<CR>

    " to be able to search on files through path
    set path=$PWD/**

    noremap <left> 20<C-y>20k
    noremap <right> 20<C-e>20j
    noremap <up> 2<C-y>
    noremap <down> 2<C-e>

    nnoremap <silent> <space><tab> <cmd>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')<cr>

    "WINDOWS
        nmap gh <C-w>h
        nmap gl <C-w>l
        nmap gj <C-w>j
        nmap gk <C-w>k
        nmap gH <C-w>H
        nmap gL <C-w>L
        nmap gJ <C-w>J
        nmap gK <C-w>K

        nmap gal <C-w>v
        nmap gah <C-w>v<C-w>L
        nmap gaj <C-w>s<C-w>K
        nmap gak <C-w>s

        " jump on float window
        nmap gw <C-w>w
        nmap go :on<Cr>
        nmap g= <C-w>=

        "RESIZE
        nnoremap <M->> <C-w>5+
        nnoremap <M-<> <C-w>5-
        nnoremap <M-.> <C-w>5>
        nnoremap <M-,> <C-w>5<

    "SPACEMACS-LIKE COMMANDS
        nnoremap <space>d :Bd!<CR>
        nnoremap <space>ba :w <bar> silent %bd! <bar> e# <bar> bd# <CR>
        nnoremap <space>bd <Esc>:diffthis<Cr>gg<C-w>w:diffthis<Cr>gg

    "GO TO PREVIOUS TAB WHEN CURRENT ONE IS CLOSED
        let s:prevtabnum=tabpagenr('$')
        augroup TabClosed
            autocmd! TabEnter * :if tabpagenr('$')<s:prevtabnum && tabpagenr()>1
                        \       |   tabprevious
                        \       |endif
                        \       |let s:prevtabnum=tabpagenr('$')
        augroup END

    "SEARCH
        set ignorecase
        set incsearch
        set hlsearch
        vnoremap / <Esc>/\%V
        

    "SEARCH
        " nnoremap / /\v
        " vnoremap / /\v

    "AUTO SCROLL FIX

        " Save current view settings on a per-window, per-buffer basis.
        function! AutoSaveWinView()
            if !exists("w:SavedBufView")
                let w:SavedBufView = {}
            endif
            let w:SavedBufView[bufnr("%")] = winsaveview()
        endfunction

        " Restore current view settings.
        function! AutoRestoreWinView()
            let buf = bufnr("%")
            if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
                let v = winsaveview()
                let atStartOfFile = v.lnum == 1 && v.col == 0
                if atStartOfFile && !&diff
                    call winrestview(w:SavedBufView[buf])
                endif
                unlet w:SavedBufView[buf]
            endif
        endfunction

        " When switching buffers, preserve window view.
        if v:version >= 700
            autocmd BufLeave * call AutoSaveWinView()
            autocmd BufEnter * call AutoRestoreWinView()
        endif

    "AUTO SAVE QUICKFIX

        if exists('g:loaded_hqf')
            finish
        endif
        let g:loaded_hqf = 1

        function! s:load_file(type, bang, file) abort
            let l:efm = &l:efm
            let &l:errorformat = "%-G%f:%l: All of '%#%.depend'%.%#,%f%.%l col %c%. %m"
            let l:cmd = a:bang ? 'getfile' : 'file'
            exec a:type.l:cmd.' '.a:file
            let &l:efm = l:efm
        endfunction

        command! -complete=file -nargs=1 -bang Q call <SID>load_file('c', <bang>0, <f-args>)
        command! -complete=file -nargs=1 -bang Lfile call <SID>load_file('l', <bang>0, <f-args>)

"SYNTAX
    nnoremap <esc> :noh<Enter>:echom ""<Enter>
    nnoremap <tab> ]s
    nnoremap <s-tab> [s
    "FOLDING
        "no foldings by default
        set nofen
        autocmd Filetype vim set foldmethod=indent
        autocmd BufRead *.txt set foldmethod=indent

    "TABS
        set smartindent
        set shiftwidth=4 smarttab expandtab
        set tags=./tags,tags;$HOME

    "MARKDOWN
        vnoremap <silent> ic :<C-U>call <SID>MdCodeBlockTextObj('i')<CR>
        onoremap <silent> ic :<C-U>call <SID>MdCodeBlockTextObj('i')<CR>

        vnoremap <silent> ac :<C-U>call <SID>MdCodeBlockTextObj('a')<CR>
        onoremap <silent> ac :<C-U>call <SID>MdCodeBlockTextObj('a')<CR>

        function! s:MdCodeBlockTextObj(type) abort
          " the parameter type specify whether it is inner text objects or arround
          " text objects.
          let start_row = searchpos('\s*```', 'bn')[0]
          let end_row = searchpos('\s*```', 'n')[0]

          let buf_num = bufnr()
          if a:type ==# 'i'
            let start_row += 1
            let end_row -= 1
          endif
          " echo a:type start_row end_row

          call setpos("'<", [buf_num, start_row, 1, 0])
          call setpos("'>", [buf_num, end_row, 1, 0])
          execute 'normal! `<V`>'
        endfunction

    "AUTOCMD
        
        augroup sql_settings
            au FileType sql setl formatprg=/opt/homebrew/bin/pg_format\ -s\ 2
        augroup end

"END
