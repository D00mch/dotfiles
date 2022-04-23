(module init
  {require {core aniseed.core
            nvim aniseed.nvim
            u aniseed.nvim.util
            key which-key
            plenary plenary.filetype
            util util}
   require-macros [macros]})

(require :plugin)

(defn- map [mode from to]
  (util.m mode from to {:noremap true}))

;; open Help in full window
(vim.api.nvim_command "command! -nargs=1 -complete=help H help <args> | silent only")

;; terminal, go in normal mode
(map :t "®" "<C-\\><C-n>")
(map :t "π" "<Esc>pa") ; alt+p to paste (karabiner map cmd+v to alt+p for vims)
(map :t "ø" "<C-w>") ; alt+o to delete a word 

;; restore last known position
(autocmd                                    
  :BufReadPost
  "*"
  "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif")

(autocmd :FileType :clojure ":lua require('lang.clojure')")

(vim.api.nvim_create_autocmd 
  "BufRead,BufNewFile"
  {:pattern "*.cljd"
   :callback (fn [args] 
               (vim.api.nvim_command "setfiletype clojure")
               ;; until https://github.com/nvim-lua/plenary.nvim/pull/356
               (plenary.add_file "ext"))})

;; navigation settngs
;; delete all buffers except this one
(map :n :<space>ba ":w <bar> silent %bd! <bar> e# <bar> bd# <CR>") 
(map :n :≈ ":silent! BD!<cr>") ;; alt + x to delete a buffer
(util.m :i :≈ "<Esc>≈" {:noremap false})

;; language setup
(vim.api.nvim_command "set keymap=russian-jcukenmac")
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

;; tabs (remaped with common aproach with karabiner)
(map :n :<C-y> :gt)
(map :n :<C-t> :gT)
(map :i :<C-y> :<Esc>gt)
(map :i :<C-t> :<Esc>gT)
(map :n ">>" ":tabmove +1<cr>")
(map :n "<<" ":tabmove -1<cr>")
