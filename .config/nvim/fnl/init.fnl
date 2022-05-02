(module init
  {require {nvim aniseed.nvim
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
(map :t "®" "<C-\\><C-n>") ; alt+r
(map :t "π" "<Esc>pa") ; alt+p to paste (karabiner map cmd+v to alt+p for vims)
(map :t "<Esc>" "<C-\\><C-n>")

;; restore last known position
(autocmd                                    
  :BufReadPost
  "*"
  "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif")

(autocmd :FileType :dart "set shiftwidth=2 smarttab expandtab")

(vim.api.nvim_create_autocmd 
  "FileType"
  {:pattern "clojure"
   :callback (fn [args] 
               (let [clj (require :lang.clojure)]
                 (clj.set-up-mappings)))})

(vim.api.nvim_create_autocmd 
  "BufRead,BufNewFile"
  {:pattern "*.cljd"
   :callback (fn [args] 
               (vim.api.nvim_command "setfiletype clojure")
               ;; until https://github.com/nvim-lua/plenary.nvim/pull/356
               (plenary.add_file "ext"))})

;; navigation settngs
;; delete all buffers except this one
(map :n :<space>bd ":silent! BD!<cr>")
(map :n :<space>ba ":w <bar> silent %bd! <bar> e# <bar> bd# <CR>") 
(map :n :≈ ":silent! bd!<cr>") ;; alt + x to delete a buffer
(util.m :i :≈ "<Esc>≈" {:noremap false})

;; language setup
(vim.cmd "lang en_US.UTF-8") ;; tmp fix until nvim 0.7.1 https://github.com/neovim/neovim/issues/5683#issuecomment-1114756116
(vim.api.nvim_command "set keymap=russian-jcukenmac")
(set nvim.o.iminsert 0)
(set nvim.o.imsearch 0)
(map :i "<c-l>" "<c-^>")

(key.register
  {:<Space>
   {:r [(.. "<Cmd>set iminsert=1 imsearch=1<bar>"
            "lang ru_RU.UTF-8<bar>"
            "setlocal spell! spelllang=ru_ru,en_us<cr>") "set rus lang"]
    :e [(.. "<Cmd>set iminsert=0 imsearch=0<bar>"
            "lang en_US.UTF-8<bar>"
            "setlocal spell! spelllang=ru_ru,en_us<cr>") "set eng lang"]}})

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
