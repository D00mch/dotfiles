" vim:foldmethod=marker
" ============================================================================
" File:         TclShell.vim (Autoload)
" Last Changed: Mon Mar 19 09:58 AM 2012 EDT
" Maintainer:   Lorance Stinson AT Gmail...
" License:      Public Domain
"
" Description:  The functional parts of TclShell.
"               Only load it if/when the shell is called.
" ============================================================================

" Section: Initialization

" Only load once. {{{1
if exists("g:loadedTclShellAuto") || &cp || !has('tcl')
    finish
endif
let g:loadedTclShellAuto= 1
" }}}

" Defaults  {{{1

" Function: s:SetDefault(option, default) - Set a default value for an option.
function! s:SetDefault(option, default)
    if !exists(a:option)
        execute 'let ' . a:option . '=' . string(a:default)
    endif
endfunction

" Default prompt.
call s:SetDefault('g:TclShellPrompt',           "Tcl Shell # ")

" Default to insert mode in the Shell window.
call s:SetDefault('g:TclShellInsert',           1)

" Enable the extended Tcl Shell Window mappings by default.
call s:SetDefault('g:TclShellDisableExtMap',    0)

" Default to a maximum of 50 items in the history.
" Set to 0 to disable history.
call s:SetDefault('g:TclShellHistMax',          50)

" No need for the function any longer.
delfunction s:SetDefault

" The file containing the Tcl code.
let g:TclShellTclFile = expand('<sfile>:p:r') . '.tcl'
if !filereadable(g:TclShellTclFile)
    echoerr 'Unable to read TclShell.tcl!'
    echoerr 'Please make sure this file is present.'
    echoerr 'Loading of TclShell aborted!'
    finish
endif

" Cache the prompt length for calculations and key maps.
" Save the prompt in case the user changes it.
let s:prompttext = g:TclShellPrompt
let s:promptlen = len(s:prompttext)

" Start with no history.
let s:TclShellHistory=[]
let s:TclShellHistPtr=-1
" }}}

" Section: Functions.

" Function: TclShell#Eval(...)      -- Evaluates Tcl Code. {{{1
function! TclShell#Eval(...) range
    " Note the current buffer information if a range is passed.
    let l:curbufnr = bufnr('%')
    let l:lastline = line('$')
    let l:fname = substitute(expand('%:p'), '\\', '\\\\', 'g')

    " Open the Tcl window.
    call TclShell#OpenShell()

    " Get the code to execute.
    if a:0 != 0 && a:1 != ''
        " Code was passed.
        call setline('$', getline('$') . a:1)
        call TclShell#Exec()
    elseif a:firstline == 1 && a:lastline == l:lastline
        " Source the file.
        call setline('$', getline('$') . 'source {' . l:fname . '}')
        call TclShell#Exec()
    else
        " Process a range.
        let l:lines = getbufline(l:curbufnr, a:firstline, a:lastline)
        let l:code = join(l:lines, "\n")

        " Tell the user what we are doing.
        let l:descr = '# Evaluating line'
        if a:firstline == a:lastline
            let l:descr .= ' ' . a:firstline
        else
            let l:descr .= 's ' . a:firstline . ' to ' . a:lastline
        endif
        let l:descr .= ' of file ' . l:fname
        call setline('$', getline('$') . l:descr)

        " Execute the Tcl code.
        execute 'tcl ::_TclShellEval {' . l:code . '}'

        " Redisplay the prompt.
        call TclShell#Prompt()
    endif
endfunction " }}}

" Function: TclShell#OpenShell(...) -- Open the Tcl Shell buffer. {{{1
function! TclShell#OpenShell()
    " If not already in the buffer create/open it.
    if expand("%:p:t") != "_TclShell_"
        " Make the buffer or switch to it.
        if bufexists("_TclShell_")
            let winnbr = bufwinnr("_TclShell_")
            if winnbr == -1
                sbuffer _TclShell_
                call TclShell#Init()
            else
                execute winnbr . 'wincmd w'
            endif
        else
            split _TclShell_
            call TclShell#Init()
        endif

        " Reset these every time the buffer is entered.
        setlocal buftype=nofile
        setlocal bufhidden=hide
        setlocal nobuflisted
        setlocal noswapfile
        call TclShell#Prompt()
    endif
endfunction " }}}

" Function: TclShell#Init()         -- Initialize a new buffer. {{{1
function! TclShell#Init()
    " Standard key mappings to execute code.
    nnoremap <silent> <buffer> <cr>             :call TclShell#Exec()<cr>
    inoremap <silent> <buffer> <cr>        <Esc>:call TclShell#Exec()<cr>

    " Extended key mappings to behave like a terminal.
    if !g:TclShellDisableExtMap
        " Control Keys.
        exec 'nnoremap <silent> <buffer> <C-A>      0' . s:promptlen . 'l'
        exec 'inoremap <silent> <buffer> <C-A> <Esc>0' . s:promptlen . 'li'
        nnoremap <silent> <buffer> <C-B>            h
        inoremap <silent> <buffer> <C-B>       <Esc>ha
        nnoremap <silent> <buffer> <C-D>            :close<cr>
        inoremap <silent> <buffer> <C-D>       <Esc>:close<cr>
        nnoremap <silent> <buffer> <C-E>            $
        inoremap <silent> <buffer> <C-E>       <Esc>A
        nnoremap <silent> <buffer> <C-F>            l
        inoremap <silent> <buffer> <C-K>       <Esc>ld$a
        nnoremap <silent> <buffer> <C-K>            d$
        inoremap <silent> <buffer> <C-F>       <Esc>la
        nnoremap <silent> <buffer> <C-L>            :call TclShell#Clear()<cr>
        inoremap <silent> <buffer> <C-L>       <Esc>:call TclShell#Clear()<cr>
        nnoremap <silent> <buffer> <C-N>            :call TclShell#Hist(0)<cr>
        inoremap <silent> <buffer> <C-N>       <Esc>:call TclShell#Hist(0)<cr>
        nnoremap <silent> <buffer> <C-P>            :call TclShell#Hist(1)<cr>
        inoremap <silent> <buffer> <C-P>       <Esc>:call TclShell#Hist(1)<cr>
        inoremap <silent> <buffer> <C-T>       <Esc>hxpa
        nnoremap <silent> <buffer> <C-T>            hxp
        exec 'nnoremap <silent> <buffer> <C-U>      0' . s:promptlen . 'lD'
        exec 'inoremap <silent> <buffer> <C-U> <Esc>0' . s:promptlen . 'lDa'

        " Alt Keys.
        inoremap <silent> <buffer> <A-b>       <Esc>Bi
        nnoremap <silent> <buffer> <A-b>            B
        inoremap <silent> <buffer> <A-d>       <Esc>ldwgi
        nnoremap <silent> <buffer> <A-d>            dw
        inoremap <silent> <buffer> <A-f>       <Esc>Ea
        nnoremap <silent> <buffer> <A-f>            El
    endif

    " Configure the syntax.
    exec 'syn include @TclSyn syntax/tcl.vim'
    exec 'syn region TclPrompt matchgroup=TclShell keepend start="' .
       \ s:prompttext . '" end=+$+ contains=@TclSyn'
    exec "hi link TclShell Comment"
    if g:TclShellInsert
        autocmd BufEnter <buffer> startinsert!
    endif

    " Load the TCL code to execute Tcl Shell input.
    execute ':tclfile ' . g:TclShellTclFile
endfunction " }}}

" Function: TclShell#Prompt()       -- Display the prompt. {{{1
function! TclShell#Prompt()
    let l:line = getline("$")
    if matchstr(l:line, s:prompttext) == ""
        if getline("$") != ""
            call append(line('$'), "")
        endif
        call setline(line('$'), s:prompttext)
    endif
    call cursor('$',col([line('$'),'$']))
    if g:TclShellInsert
        startinsert!
    endif
    let s:TclShellHistPtr=-1
endfunction " }}}

" Function: TclShell#Hist(dir)      -- Move in the history. {{{1
" Move forward and back in history.
" Direction is true for up, false for down.
function! TclShell#Hist(dir)
    if len(s:TclShellHistory)
        if a:dir
            if (s:TclShellHistPtr + 1) < len(s:TclShellHistory)
                let s:TclShellHistPtr += 1
            endif
        else
            if s:TclShellHistPtr >= 0
                let s:TclShellHistPtr -= 1
            endif
        endif
        if s:TclShellHistPtr >= 0
            let l:histtext = s:TclShellHistory[s:TclShellHistPtr]
        else
            let l:histtext = ''
        endif
        call setline('.', s:prompttext . l:histtext)
    endif
    if g:TclShellInsert
        startinsert!
    endif
endfunction " }}}

" Function: TclShell#Clear()        -- Clear the shell buffer. {{{1
function! TclShell#Clear()
    normal ggdG
    :call TclShell#Prompt()
endfunction " }}}

" Function: TclShell#Exec()         -- Execute a line of Tcl code. {{{1
function! TclShell#Exec()
    let l:line = getline('.')
    if match(l:line, s:prompttext) < 0
        echo "Not on the command line"
        return TclShell#Prompt()
    else
        let l:tclcode = substitute(l:line, s:prompttext, '', '')
        if l:tclcode == ""
            return TclShell#Prompt()
        elseif l:tclcode =~ '^\s*clear\s*$'
            return TclShell#Clear()
        else
            if g:TclShellHistMax
                if len(s:TclShellHistory) >= g:TclShellHistMax
                    let s:TclShellHistory = remove(s:TclShellHistory, -1)
                endif
                call insert(s:TclShellHistory, l:tclcode)
            endif
            execute 'tcl ::_TclShellEval {' . l:tclcode . '}'
        endif
        call TclShell#Prompt()
    endif
endfunction " }}}
