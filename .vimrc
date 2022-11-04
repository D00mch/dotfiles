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
    nnoremap <Bs> <C-o>

    "INFO
        noremap <leader>z g<C-g>
        vnoremap <leader>z g<C-g>:<C-U>echo v:statusmsg<CR>

    "OBJECTS
        onoremap w iw
        onoremap W iW
        nnoremap vw viw
        nnoremap vW viW
        onoremap iq i"
        onoremap aq a"

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
        vnoremap v <C-v>

    "PASTE
        "below - current line
        nnoremap cl mX"9yy"9p`Xj
        "below - empty line
        nnoremap <space>o mXo<Esc><Esc>`X

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
        "remove unnecessary spaces at the end of lines
        nnoremap <space>sr :%s/\s\s*$//g<cr><c-o>:noh<cr>:echom ""<cr>

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
        "alt + w
        nnoremap ∑ <C-w>
        nnoremap gh <C-w>h
        nnoremap gl <C-w>l
        nnoremap gj <C-w>j
        nnoremap gk <C-w>k
        nnoremap gw <C-w>w

        "RESIZE
        nnoremap g= <C-w>5+
        nnoremap g- <C-w>5-
        "alt+
        nnoremap ≠ <C-w>5>+
        nnoremap – <C-w>5<+

    "SPACEMACS-LIKE COMMANDS
        nnoremap <space>d :silent! :bp<bar>sp<bar>bn<bar>bd!<CR><cr>
        nnoremap <space>a :w <bar> silent %bd! <bar> e# <bar> bd# <CR>

        "alt + x to delete a buffer; cmd+w with karabiner
        nnoremap ≈ :close<cr>
        imap     ≈ <Esc>≈

    "SEARCH
        set ignorecase
        set incsearch
        set hlsearch

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
"END
