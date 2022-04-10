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

;; terminal, go in normal mode
(map :t "®" "<C-\\><C-n>")

;; restore last known position
(nvim.ex.autocmd                                    
  :BufReadPost
  "*"
  "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif")

(nvim.ex.autocmd
  :FileType
  "clojure"
  ":lua require('lang.clojure')")

;; tabs
(vim.cmd "set omnifunc=syntaxcomplete#Complete")
(set nvim.g.SuperTabDefaultCompletionType "<c-n>")

;; cljd is also a clojure
(vim.cmd "au! BufRead,BufNewFile *.cljd setfiletype clojure")

;; language setup
(vim.cmd "set keymap=russian-jcukenmac")
(set nvim.o.iminsert 0)
(set nvim.o.imsearch 0)
(map :n "<leader>se" ":setlocal spell! spelllang=en<cr>")
(map :n "<leader>sr" ":setlocal spell! spelllang=ru<cr>")
(map :i "<c-l>" "<c-^>")
(map :n "<space>r" ":set iminsert=1 imsearch=1<cr>")
(map :n "<space>e" ":set iminsert=0 imsearch=0<cr>")
(comment "to be continue...")
