(module init
  {require {core aniseed.core
            nvim aniseed.nvim
            u aniseed.nvim.util
            util util}})

(require :plugin)

(defn- map [mode from to]
  (util.m mode from to {:noremap false}))

;; open Help in full window
(vim.cmd "command! -nargs=1 -complete=help H help <args> | silent only")

(map :t "®" "<C-\\><C-n>")
(nvim.ex.autocmd                                    ; restore last known position
                 :BufReadPost
                 "*"
                 "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif")

(do (comment "Syntax")
  (vim.cmd "set fdm=syntax")
  (nvim.ex.autocmd :FileType "vim,fennel" "set foldmethod=indent")
  (nvim.ex.autocmd :BufRead "*.txt" "set foldmethod=indent")

  (vim.cmd "set omnifunc=syntaxcomplete#Complete")  ; tabs 
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
  (vim.cmd "au! BufRead,BufNewFile *.cljd setfiletype clojure")
  (comment "to be continue..."))
