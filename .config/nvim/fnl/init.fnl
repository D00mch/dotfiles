(module init
  {require {_ plugin
            nvim aniseed.nvim
            u aniseed.nvim.util
            plenary plenary.filetype
            clipboard deferred-clipboard
            numb numb
            {: dec : inc} aniseed.core
            {: kset} util}
   require-macros [macros]})

(clipboard.setup) ;; do not put every 'x' to clipboard
(numb.setup)

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

(defn close-or-buffer-delete []
  (if (not (pcall vim.cmd "close"))
    (vim.cmd "bd")))

(kset [:n :x] :<D-w> close-or-buffer-delete {:desc "Close or :bd"})
(kset :i :<D-w> :<Esc><D-w> {:remap true})
(kset :c :<D-w> :<Esc><Esc>)

(kset :n :<D-z> :u)
(kset :x :<D-z> :<Esc>ugv)
(kset :i :<D-z> :<Esc><D-z>a {:remap true})

;; Cmd line

(kset [:n :x] :<D-f> :/)
(kset [:i :t] :<D-f> :<Esc><D-f> {:remap true})

;; restore last known position
(vim.api.nvim_create_autocmd
  :BufReadPost
  {:pattern :*
   :group (vim.api.nvim_create_augroup :LastPosition {:clear true})
   :callback #(vim.cmd "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif")})

(vim.api.nvim_create_autocmd
  :FileType
  {:pattern "clojure"
   :group    (vim.api.nvim_create_augroup :ClojureSetup {:clear true})
   :callback #(let [clj (require :lang.clojure)]
                (clj.set-up-mappings))})

(vim.api.nvim_create_autocmd
  "BufRead,BufNewFile"
  {:pattern "*.cljd"
   :group    (vim.api.nvim_create_augroup :ClojureDartSetup {:clear true})
   :callback (fn [args]
               (vim.api.nvim_command "setfiletype clojure")
               ;; until https://github.com/nvim-lua/plenary.nvim/pull/356
               (plenary.add_file "ext"))})

;; navigation settngs
;; delete all buffers except this one
(set nvim.o.mouse "a")

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
