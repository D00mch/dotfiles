(module init
  {require {_ plugin
            nvim aniseed.nvim
            u aniseed.nvim.util
            key which-key
            {: toggle} plugin.which
            plenary plenary.filetype
            {: kset} util}
   require-macros [macros]})

(defn- map [mode from to]
  (kset [mode] from to {:noremap true}))

;; open Help in full window
(vim.api.nvim_command "command! -nargs=1 -complete=help H help <args> | silent only")

;; cmd

(kset :x :<D-c> :y)

(kset :n :<D-v> :p)
(kset :t :<D-v> :<Esc>pa)
(kset [:i :c] :<D-v> :<C-r><C-o>*)

(kset :n :<D-s> ":w<Cr>")
(kset :i :<D-s> :<Esc>:w<CR>a)

(kset :n :<D-a> :ggVG)
(kset :x :<D-a> :<Esc>ggVG)
(kset :i :<D-a> :<Esc><D-a> {:remap true})
(kset :c :<D-a> :<C-f><Esc><D-a> {:remap true})

(kset [:n :x] :<D-w> ":q<Cr>")
(kset :i :<D-w> :<Esc><D-w> {:remap true})
(kset :c :<D-w> :<Esc><Esc>)

(kset :n :<D-z> :u)
(kset :x :<D-z> :<Esc>ugv)
(kset :i :<D-z> :<Esc><D-z>a {:remap true})

;; Cmd line

(kset [:n :x] :<D-f> :/)
(kset [:i :t] :<D-f> :<Esc><D-f> {:remap true})

;; terminal, go in normal mode
(kset :t "®" "<C-\\><C-n>") ; alt+r
(kset :t "π" "<Esc>pa") ; alt+p to paste (karabiner map cmd+v to alt+p for vims)
(kset :t "≈" "®:close<cr>" {:noremap false})
(kset :t "<Esc>" "<C-\\><C-n>")

;; restore last known position
(autocmd
  :BufReadPost
  "*"
  "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif")

(autocmd :FileType :dart "set shiftwidth=2 smarttab expandtab")
(autocmd :FileType :json "set shiftwidth=2 smarttab expandtab")
(autocmd :FileType :http "set shiftwidth=2 smarttab expandtab")

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

(when vim.g.neovide

  (set nvim.g.neovide_cursor_vfx_mode "railgun")
  (toggle "t" "transparency" ":NeovideToggleTransparency<Cr>")

  (vim.api.nvim_create_user_command :NeovideToggleTransparency
                                    (fn []
                                      (set nvim.g.neovide_transparency 
                                           (if (= 1 nvim.g.neovide_transparency) 0.9 1)))
                                    {:nargs :* :desc "Insert markdown header"}))


;; diff split
(defn- compare-to-clipboard []
  (let [ftype (vim.api.nvim_eval "&filetype")]
    (->
      "execute 'normal! \"xy'
      tabnew
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

(kset [:x] :<Space>cd compare-to-clipboard {:desc "Clipboard Diff"})

;; multicursor
(kset :n :cn "*``cgn")
(kset :n :cN "*``cgN")

(set vim.g.mc "y/\\V<C-r>=escape(@\", '/')<CR><CR>")
(kset :x :cn "g:mc . \"``cgn\"" {:expr true})
(kset :x :cN "g:mc . \"``cgN\"" {:expr true})

(vim.cmd "
function! SetupCR()
  nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
endfunction")

(kset :n :cq ":call SetupCR()<CR>*``qz")
(kset :n :cQ ":call SetupCR()<CR>*``qz")

;; yank highlight
(vim.api.nvim_create_autocmd
  :TextYankPost
  {:group (vim.api.nvim_create_augroup :yank_highlight {})
   :pattern :*
   :callback 
   (fn [] (vim.highlight.on_yank {:higroup :IncSearch :timeout 300}))})

;; formatters

(key.register
  {:<Space>
   {:f [{:j [:!jq<cr> "Json"]
         :s ["!pg_format -s 2<cr>" "SQL"]}
        "Format"]}})
