(module init
  {require {nvim aniseed.nvim
            u aniseed.nvim.util
            key which-key
            {: toggle} plugin.which
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
(util.m :t "≈" "®:close<cr>" {:noremap false})
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
(set nvim.o.mouse "a")

;; language setup
(vim.cmd "lang en_US.UTF-8") ;; tmp fix until nvim 0.7.1 https://github.com/neovim/neovim/issues/5683#issuecomment-1114756116
(vim.api.nvim_command "set keymap=russian-jcukenmac")
(set nvim.o.iminsert 0)
(set nvim.o.imsearch 0)

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

(defn font-size! [diff]
  (let [font nvim.o.guifont
        size (-> (nvim.o.guifont:match "h(%d+)$") tonumber (+ diff))]
    (set nvim.o.guifont (font:gsub "%d+$" size))))

(vim.keymap.set :n :<Space>+ (fn [] (font-size! 1)))
(vim.keymap.set :n :<Space>- (fn [] (font-size! -1)))

(set nvim.g.neovide_cursor_vfx_mode "railgun")
(toggle "t" "transparency" ":NeovideToggleTransparency<Cr>")

(vim.api.nvim_create_user_command :NeovideToggleTransparency 
                                  (fn []                                  
                                    (vim.cmd (..  "let g:neovide_transparency="
                                                 (if (= 1 nvim.g.neovide_transparency) 0.9 1))) )
                                  {:nargs :* :desc "Insert markdown header"})

;; tabs (remaped with common aproach with karabiner)
(map "" :<C-y> :gt)
(map "" :<C-t> :gT)
(map :i :<C-y> :<Esc>gt)
(map :i :<C-t> :<Esc>gT)
(map :n ">>" ":tabmove +1<cr>")
(map :n "<<" ":tabmove -1<cr>")

;; diff split
(defn- compare-to-clipboard []
  (let [ftype (vim.api.nvim_eval "&filetype")]
    (-> 
      "execute 'normal! \"xy'
      vsplit
      enew
      normal! P
      setlocal buftype=nowrite
      set filetype=%s
      diffthis
      execute \"normal! \\<C-w>\\<C-w>\"
      enew
      set filetype=%s
      normal! \"xP
      diffthis"
      (string.format ftype ftype)
      vim.cmd)))

(vim.keymap.set :x :<Space>cb compare-to-clipboard)
