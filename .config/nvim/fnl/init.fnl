(module init
  {require {core aniseed.core
            nvim aniseed.nvim
            util util}})

(defn- map [mode from to]
  (util.m mode from to {:noremap false}))

(do (comment "Editing")
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
  (comment "to be continue..."))

(do (comment "Syntax")
  (vim.cmd "set fdm=syntax")
  (nvim.ex.autocmd :FileType "vim,fennel" "set foldmethod=indent")
  (nvim.ex.autocmd :BufRead "*.txt" "set foldmethod=indent")

  ; TODO: move to tab plugin
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

;; Load all modules in no particular order.
(->> (util.glob (.. util.config-path "/lua/plugin/*.lua"))
     (core.run! (fn [path]
                 (require (string.gsub path ".*/(.-)/(.-)%.lua" "%1.%2")))))


