(module init
  {require {core aniseed.core
            nvim aniseed.nvim
            util util}})

(defn- map [mode from to]
  (util.m mode from to {:noremap false}))

(do (comment "Defaults")
  (nvim.ex.set "clipboard+=unnamed")               ; osx buffer
  (set nvim.g.mapleader ",")
  (set nvim.g.maplocalleader ",")
  (nvim.ex.set :number)                            ; current line number
  (nvim.ex.set :relativenumber)
  (nvim.ex.set :cursorline)
  (nvim.ex.set :cursorcolumn))

(do (comment "Editing")
  (map :n "U" "<C-r>")                              ; U to redo
  (util.add-glob :shut_up_and_close                 ; add a function to a global scope
                 (fn [] 
                   (nvim.fn.execute ":wa")
                   (nvim.fn.execute ":qa!")))
  (map :n "œ" ":lua shut_up_and_close()<cr>")       ; save all buffers and close (!)
  (map :n "ß" ":wa<cr>")                            ; save all buffers
  (map :n "cl" "mX\"9yy\"9p`Xj")                    ; copy-pase a line belowe
  (map :n "<space>o" "o<Esc><Esc>")                 ; paste an empty line below
  (nvim.ex.autocmd                                  ; restore last known position
                   :BufReadPost
                   "*"
                   "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif")
  (nvim.ex.set :undofile)

  (set nvim.o.undodir (.. (nvim.fn.stdpath "data")  ; persistent undo settings
                          "/undo"))            
  (set nvim.o.undolevels 1000)
  (set nvim.o.undoreload 10000)
  (map :n "<space>u" ":UndotreeToggle<cr>")         ; undo tree
  (map :n "yf" (.. ":let @+=expand(\"%:p\")<cr>"    ; put file path in clipboard
                   ":echom expand(\"%:p\")<cr>"))
  (map :n "yd" (.. ":let @+=expand(\"%:p:h\")<cr>"  ; put dir path in clipboard
                   ":echom expand(\"%:p:h\")<cr>"))     
  (map :n "<space>;" "gcc")                         ; comment like in spacemacs 
  (comment "to be continue..."))

(do (comment "Navigation")
  (nvim.ex.set :ignorecase) 
  (set nvim.o.path "$PWD/**")                       ; search on files in path

  (map :n "<leader>sd" ":cd %:p:h<CR>")
  (map "" "<space>h" "^")
  (map "" "<space>l" "g_")
  (map :n "<space><tab>" ":e#<cr>")                 ; switch betwen 2 files like in spacemacs
  (map :n "gh" "gT")
  (map :n "gl" "gt")
  (map :n "<space>bd" ":bd<cr>")                    ; delete buffer like in spacemacs

  (map :n "∆" "<C-W>j")                             ; alt + j
  (map :n "˚" "<C-W>k")                             ; alt + k
  (map :n "˙" "<C-W>h")                             ; alt + h 
  (map :n "¬" "<C-W>l")                             ; alt + l
  (map :n "∑" "<C-W>")                               ; alt + w

  (map :n "®" "<C-\\><C-n>")                        ; alt + r

  ;; TODO: move in telescope
  (map :n "∫" ":Rg <C-R><C-W><CR>")                 ; alt + b to fine this word in the project (idea)
  (map :n "<space>pa" ":execute 'silent! update'<Bar>Rg<cr>")
  (map :n "<space>pf" ":execute 'silent! update'<Bar>FZF<cr>")
  (map :n "<space>bb" ":execute 'silent! update'<Bar>Buffers<cr>")

  (map "" "/" "/\\v")
  (comment "to be continue..."))

(do (comment "Syntax")
  (vim.cmd "set fdm=syntax")
  (nvim.ex.autocmd "BufRead,BufNewFile" "*.lib" "set filetype=sh")
  (nvim.ex.autocmd :FileType "vim,fennel" "set foldmethod=indent")
  (nvim.ex.autocmd :BufRead "*.txt" "set foldmethod=indent")

  ; TODO: move to tab plugin
  (map "" "<tab>" ":noh<Enter>:echom \"\"<Enter>")     ; set up tabs
  (nvim.ex.set :smartindent) 
  (vim.cmd "set shiftwidth=4 smarttab expandtab")
  ; (nvim.ex.autocmd 
  ;   :InsertLeave "*" "if pumvisible() == 0 | pclose | endif") 
  ; (nvim.ex.autocmd 
  ;   :CompleteDone "*" "if pumvisible() == 0 | pclose | endif") 
  (vim.cmd "set omnifunc=syntaxcomplete#Complete")
  (set nvim.g.SuperTabDefaultCompletionType "<c-n>") 

  (vim.cmd "set keymap=russian-jcukenmac")          ; set up russian lang
  (set nvim.o.iminsert 0)
  (set nvim.o.imsearch 0)
  (map :n "<leader>se"                              ; check eng spelling 
       ":setlocal spell! spelllang=en<cr>")
  (map :n "<leader>sr" ":setlocal spell! spelllang=ru<cr>")
  (map :n "<c-l>" "<c-^>")                          ; change lang in insert mode
  (map :n "<space>r" 
       ":set iminsert=1 imsearch=1<cr>")            ; change to russian (search included)
  (map :n "<space>e" ":set iminsert=0 imsearch=0<cr>")

  ;; TODO: find how to write in on line
  (nvim.ex.autocmd                                  ; cljd are clojure 
    :BufRead "*.cljd" "setfiletype clojure")
  (nvim.ex.autocmd 
    :BufNewFile "*.cljd" "setfiletype clojure")
  (comment "to be continue...")) ; nil

        
; (tset _G :markdown_level
;         (fn []
;           (if 
;             (string.find (vim.fn.getline vim.v.lnum)  "^# .*$")
;             ">1"

;             (string.find (vim.fn.getline vim.v.lnum)  "^## .*$")
;             ">2"

;             (string.find (vim.fn.getline vim.v.lnum)  "^### .*$")
;             ">3"

;             (string.find (vim.fn.getline vim.v.lnum)  "^#### .*$")
;             ">4"

;             "=")))
; (nvim.ex.autocmd :BufEnter "*.md" "setlocal foldexpr=MarkdownLevel()")
; (nvim.ex.autocmd :BufEnter "*.md" "setlocal foldmethod=expr")

;             (string.find (vim.fn.getline vim.v.lnum)  "^##### .*$")
;             ">5"

;; Load all modules in no particular order.
(->> (util.glob (.. util.config-path "/lua/plugin/*.lua"))
     (core.run! (fn [path]
                 (require (string.gsub path ".*/(.-)/(.-)%.lua" "%1.%2")))))


