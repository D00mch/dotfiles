" ============================================================================
" File:         TclShell.vim (Plugin)
" Last Changed: Mon Mar 19 08:49 AM 2012 EDT
" Maintainer:   Lorance Stinson AT Gmail...
" License:      Public Domain
"
" Description:  Setup the keys to call TclShell.
"               The rest of the code is autoloaded when/if needed.
"
" Usage:        Execute :TclShell or type <Leader>tcl
"               (Leader is normally '\')
"               Ctrl-L clears the display.
"
" Installation: Copy the files to your ~/.vim or ~/vimfiles dorectory.
"               If using a package manager like pathogen place the whole
"               directory in the bundle directory.
"
" Note:         Can only enter one line of code.
"               Pressing Enter executes the code.
" ============================================================================

if v:version < 700
    echoerr 'TclShell requires Vim 7 or later.'
    finish
elseif exists("g:loadedTclShell") || &cp || !has('tcl')
    finish
endif
let g:loadedTclShell= 1

" End user commands.
command! TclShell :call TclShell#OpenShell()
command! -nargs=? -range=% TclEval <line1>,<line2>call TclShell#Eval(<f-args>)

" Default key map prefix.
if !exists("g:TclShellKey")
    let g:TclShellKey = '<Leader>tcl'
endif

" Key mapping to open the Tcl Shell Window.
if g:TclShellKey != ""
    exec 'nnoremap <silent> ' . g:TclShellKey .
       \ ' :call TclShell#OpenShell()<cr>'
    exec 'vnoremap <silent> ' . g:TclShellKey .
       \ " y:call TclShell#Eval('<C-R>" . '"' . "')<cr>"
endif
