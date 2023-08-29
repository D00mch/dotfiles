(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local wk (autoload :which-key))
(local
  {: assoc : update : dec : inc : first : second}
  (autoload :nfnl.core))
(local
  {: kset : bkset : bkdel : get-word-under-selection}
  (autoload :config.util))

(set vim.o.timeoutlen 250)

(fn toggle [key name cmd opts]
  ; `opts` could be a tables with :buf and :mode keys, mode string, or buf number
  (let [opts  (if 
                (= (type opts) "table")  opts
                (= (type opts) "number") {:buffer opts}
                (= (type opts) "string") {:mode opts}
                {})]
    (wk.register {:t {:name :toggle
                      key [cmd name]}}
                 (assoc opts :prefix :<Space>))))


;; language setup
(vim.api.nvim_command "set keymap=russian-jcukenmac")
(set nvim.o.iminsert 0)
(set nvim.o.imsearch 0)

(fn set-lang-cmd [lang-name]
  (let [n (if (= lang-name "en_US") 0 1)]
    (.. "set iminsert=" n " imsearch=" n "|"
        "lang " lang-name ".UTF-8|")))

(fn toggle-keyboard []
  (-> (if (= nvim.o.iminsert 0) "ru_RU" "en_US")
      set-lang-cmd
      vim.cmd))

;; Karabiner maps <CMD+X> to <CTRL+6> 
(kset [:x :n] :<C-6> toggle-keyboard {:remap true})

;; key setup
(wk.register
  {:<Space>
   {
    ;; language
    :r [(.. "<Cmd>" (set-lang-cmd "ru_RU")
            "setlocal spell! spelllang=ru_ru,en_us<cr>") "Set RUS, toggle grammar"]
    :e [(.. "<Cmd>" (set-lang-cmd "en_US")
            "setlocal spell! spelllang=ru_ru,en_us<cr>") "Set ENG, toggle grammar"]

    ;; toggle
    :t {:name :toggle

        :m [#(set vim.bo.modifiable (not vim.bo.modifiable)) :Modifiable]
        :i [#(set vim.o.list (not vim.o.list)) "List invisible chars"]
        :f [#(set nvim.g.neovide_fullscreen (not nvim.g.neovide_fullscreen)) "Full Screen"]
        :r [#(set vim.o.relativenumber (not vim.o.relativenumber)) "Relative Numbers"]
        :R ["mZ:Bd!<cr>`Z" "Refresh file"]

        ;; fan
        :a {:name :Animation
            :1 ["<cmd>CellularAutomaton make_it_rain<CR>" :Rain]
            :2 ["<cmd>CellularAutomaton game_of_life<CR>" :Game]}
        }}})

(wk.register
  {:<Space>
   {
    ;; formatters
    :f [{:j [:!jq<cr> "Json"]
         :p ["!pg_format -s 2<cr>" "pSQL"]
         :c ["<Esc>:ReplaceSelection tocamel<Cr>" "CamelCase"]
         :s ["<Esc>:ReplaceSelection tosnake<Cr>" "snake_case"]         
         :k ["<Esc>:ReplaceSelection tokebab<Cr>" "kebab-case"]
         :8 ["<Esc>:set tw=80<Cr>gvgq" "80 width"]}
        "Format"]
    }}
  {:mode :x})

;; showing tabs, spaces, end-of-lines
(set vim.o.listchars "eol:¬,space:·,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ")

;; cases
(fn tocamel [s]
  (s:gsub "[_|-](%w+)"
          (fn [part]
            (let [(before after) (values (part:sub 1 1) (part:sub 2))]
              (.. (before:upper) after)))))

(fn tosnake [s]
  (: (: (: (: (: (s:gsub "%f[^%l]%u" "_%1") :gsub "%f[^%a]%d"
                 "_%1") :gsub
              "%f[^%d]%a" "_%1")
           :gsub "(%u)(%u%l)" "%1_%2")
        :lower)
     :gsub "-" "_"))

(fn tokebab [s]
  (: (: (: (: (: (s:gsub "%f[^%l]%u" "-%1") :gsub "%f[^%a]%d"
                 "_%1") :gsub
              "%f[^%d]%a" "-%1")
           :gsub "(%u)(%u%l)" "%1-%2")
        :lower)
     :gsub "_" "-"))

(fn replace-selection [{:args f}]
  (let [[word sr sc er ec] (get-word-under-selection)  
        f                  (if
                             (= f "tokebab") tokebab
                             (= f "tosnake") tosnake
                             (= f "tocamel") tocamel)
        result             (f word)]
    (vim.api.nvim_buf_set_text 0 sr sc er ec [result])))

(vim.api.nvim_create_user_command
  :ReplaceSelection replace-selection
  {:nargs 1 :desc "Replace selected word with result function"})

{: toggle}
