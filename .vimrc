"set nocompatible
set backspace=indent,eol,start
set relativenumber
set number
set autoindent
set autochdir
set clipboard+=unnamed  " use the clipboards of vim and win
set foldmethod=syntax

" manage plugins
filetype plugin indent on

" vim-notes
:let g:notes_directories = ['~/Yandex.Disk.localized/notes/vim']
" vim-wiki
let g:vimwiki_list = [{'path':'~/Yandex.Disk.localized/notes/wiki', 'path_html':'~/Yandex.Disk.localized/notes/export/xml'}]
let g:vimwiki_folding='syntax'

"{{{ slime 
"alt + r
xmap ® <Plug>SlimeRegionSend
nmap ® <Plug>SlimeParagraphSend
"}}}

"{{{ tslime
let g:tslime_ensure_trailing_newlines = 1
let g:tslime_normal_mapping = '<localleader>t'
let g:tslime_visual_mapping = '<localleader>t'
let g:tslime_vars_mapping = '<localleader>T'
"}}}

vnoremap <silent> <Leader>t :<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>

"inoremap <leader>t <Esc>vip:<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>
"vnoremap <leader>t :<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>
"nnoremap <leader>t vip:<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>
" }}}

"{{{ spelling
"set spellfile=~/.vim/spell/{language}.{encoding}.add
nnoremap <silent> <leader>se :setlocal spell! spelllang=en<cr>
nnoremap <silent> <leader>sr :setlocal spell! spelllang=ru<cr>
"}}}

"{{{ russian mapping
set keymap=russian-jcukenmac
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

inoremap <c-l> <c-^>
"}}}

"{{{ syntax
:syntax on
set background=dark
colorscheme blackGood

:command FormatJson %!python -c "import json, sys, collections; print json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), ensure_ascii=False, indent=4)"

au BufRead,BufNewFile *.lib set filetype=sh
"}}}

set nocompatible

"{{{ search
set ignorecase
set incsearch
set hlsearch
:hi Search guibg=Yellow guifg=Black ctermbg=Yellow ctermfg=Black
"}}}

set smartindent
set shiftwidth=4 smarttab expandtab

set path+=**
set tags=./tags,tags;$HOME

"{{{escaping to the normal mode with Tab.
" See there why this takes place: http://vim.wikia.com/wiki/Avoid_the_escape_key
vnoremap <tab> <esc>
inoremap <tab> <esc>
inoremap <S-tab> <space><space><space><space>
nmap <tab> :noh<Enter>:echom ""<Enter>
nnoremap r<tab> <nop>
"}}}

"{{{ positioning
nmap <space> <nop>
map J 13jzz
map K 13kzz
map H 15h
map L 15l
map <space>h g^
map <space>l g$

noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

"alt + l
noremap ¬ 7l
"alt + h
noremap ˙ 7h
"alt + j
noremap ∆ 4gj
"alt + k
noremap ˚ 4gk
"}}}

"{{{ reg 
"alt + q
noremap œ @

"nnoremap <expr> m '"'.nr2char(getchar()).'y'
"vnoremap <expr> m '"'.nr2char(getchar()).'y'
"nnoremap <expr> <space>r '"'.nr2char(getchar()).'p'
"vnoremap <expr> <space>r '"'.nr2char(getchar()).'p'

"delete all line without putting it in registers
noremap D V"_d
"}}}

"{{{ making habitual hotkeys work in vim
"alt + d  -> copy and paste the line
nnoremap ∂ Yp

"alt + a  -> select all
nnoremap å ggVG

"alt + w  -> save
nnoremap ∑ :w<Enter>

"alt + x  -> save and quit
nnoremap ≈ :x<Enter>

"alt + q  -> quit
nnoremap œ :q<Enter>

"alt + Q  -> force quit
nnoremap Œ :q!<Enter>
"}}}

"{{{ editing
nnoremap <space>o o<Esc>
"}}}

"{{{ search, replace, regex 
nnoremap / /\v
vnoremap / /\v
"}}}


"WORKING WITH CODE 

"{{{ to color parentheses | :RainbowToggle
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'vim': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\		},
\		'html': {
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'css': 0,
\	}
\}
"}}}

"{{{ closing brace
"inoremap { {<CR>}<Esc>ko
"inoremap ( ()<C-G>U<Left>
"}}}

