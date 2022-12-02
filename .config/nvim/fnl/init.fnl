(module init
  {require {_ plugin
            nvim aniseed.nvim
            u aniseed.nvim.util
            key which-key
            {: toggle} plugin.which
            plenary plenary.filetype
            {: dec : inc} aniseed.core
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

;; restore last known position
(vim.api.nvim_create_autocmd
  :BufReadPost
  {:pattern :*
   :group (vim.api.nvim_create_augroup :LastPosition {:clear true})
   :callback (fn [] (vim.cmd "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g'\\\"\" | endif"))})

(vim.api.nvim_create_autocmd
  :FileType
  {:pattern "clojure"
   :group    (vim.api.nvim_create_augroup :ClojureSetup {:clear true})
   :callback (fn [args]
               (let [clj (require :lang.clojure)]
                 (clj.set-up-mappings)))})

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
         :p ["!pg_format -s 2<cr>" "pSQL"]
         :c ["<Esc>:ReplaceSelection tocamel<Cr>" "CamelCase"]
         :s ["<Esc>:ReplaceSelection tosnake<Cr>" "SnakeCase"]         
         :k ["<Esc>:ReplaceSelection tokebab<Cr>" "KebabCase"]}
        "Format"]}}
  {:mode :x})

;; cases

(defn tocamel [s]
  (s:gsub "[_|-](%w+)"
          (fn [part]
            (let [(before after) (values (part:sub 1 1) (part:sub 2))]
              (.. (before:upper) after)))))

(defn tosnake [s]
  (: (: (: (: (: (s:gsub "%f[^%l]%u" "_%1") :gsub "%f[^%a]%d"
                 "_%1") :gsub
              "%f[^%d]%a" "_%1")
           :gsub "(%u)(%u%l)" "%1_%2")
        :lower)
     :gsub "-" "_"))

(defn tokebab [s]
  (: (: (: (: (: (s:gsub "%f[^%l]%u" "-%1") :gsub "%f[^%a]%d"
                 "_%1") :gsub
              "%f[^%d]%a" "-%1")
           :gsub "(%u)(%u%l)" "%1-%2")
        :lower)
     :gsub "_" "-"))

(defn replace-selection [{:args f}]
  (let [[sr sc] (vim.api.nvim_buf_get_mark 0 "<")
        [sr sc] [(dec sr) sc]
        [er ec] (vim.api.nvim_buf_get_mark 0 ">")
        [er ec] [(dec er) (inc ec)]
        [word]  (vim.api.nvim_buf_get_text 0 sr sc er ec {})
        result ((if
                  (= f "tokebab") tokebab
                  (= f "tosnake") tosnake
                  (= f "tocamel") tocamel) word)]
    (vim.api.nvim_buf_set_text 0 sr sc er ec [result])))

(vim.api.nvim_create_user_command
  :ReplaceSelection replace-selection
  {:nargs 1 :desc "Replace selected word with result function"})

(kset :x :<Space>cc "<Esc>:ReplaceSelection tocamel<Cr>" "camelCase")
(kset :x :<Space>fs "<Esc>:ReplaceSelection tosnake<Cr>" "camelCase")
(kset :x :<Space>fk "<Esc>:ReplaceSelection tokebab<Cr>" "camelCase")
