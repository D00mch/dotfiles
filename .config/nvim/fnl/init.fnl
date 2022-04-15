(module init
  {require {core aniseed.core
            nvim aniseed.nvim
            u aniseed.nvim.util
            key which-key
            util util}
   require-macros [macros]})

(require :plugin)

(defn- map [mode from to]
  (util.m mode from to {:noremap false}))

;; open Help in full window
(vim.cmd "command! -nargs=1 -complete=help H help <args> | silent only")

;; terminal, go in normal mode
(map :t "®" "<C-\\><C-n>")

;; restore last known position
(autocmd                                    
  :BufReadPost
  "*"
  "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif")

(autocmd :FileType :clojure ":lua require('lang.clojure')")

;; cljd is also a clojure
(vim.cmd "au! BufRead,BufNewFile *.cljd setfiletype clojure")

;; language setup
(vim.cmd "set keymap=russian-jcukenmac")
(set nvim.o.iminsert 0)
(set nvim.o.imsearch 0)
(map :i "<c-l>" "<c-^>")

(key.register
  {:<Leader> 
   {:s {:name "lang-spelling" 
        :e [":setlocal spell! spelllang=en<cr>" "check eng spell"]
        :r [":setlocal spell! spelllang=ru<cr>" "check rus spell"]}}
   :<Space>
   {:r [":set iminsert=1 imsearch=1<cr>" "set rus lang"]
    :e [":set iminsert=0 imsearch=0<cr>" "set eng lang"]}})

;; neovide settings
(set nvim.o.guifont "Hack Nerd Font Mono:h15")
(set nvim.g.neovide_cursor_vfx_mode "railgun")
