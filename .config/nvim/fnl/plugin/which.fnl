(module plugin.which
  {autoload {wk which-key
             nvim aniseed.nvim
             {: assoc : dec : inc} aniseed.core}})

(set vim.o.timeoutlen 250)

(wk.setup
  {:plugins        {:spelling    {:enabled false
                                  :suggestions 12}}
   :popup_mappings {:scroll_down :<right>
                    :scroll_up   :<left>}})

(defn toggle [key name cmd opts]
  ; `opts` could be a tables with :buf and :mode keys, mode string, or buf number
  (let [opts  (if 
                (= (type opts) "table")  opts
                (= (type opts) "number") {:buffer opts}
                (= (type opts) "string") {:mode opts}
                {})]
    (wk.register {:t {:name :toggle
                      key [cmd name]}}
                 (assoc opts :prefix :<Space>))))

;; key setup
(wk.register
  {:<Space>
   {
    ;; language
    :r [(.. "<Cmd>set iminsert=1 imsearch=1<bar>"
            "lang ru_RU.UTF-8<bar>"
            "setlocal spell! spelllang=ru_ru,en_us<cr>") "Set RUS lang"]
    :e [(.. "<Cmd>set iminsert=0 imsearch=0<bar>"
            "lang en_US.UTF-8<bar>"
            "setlocal spell! spelllang=ru_ru,en_us<cr>") "Set ENG lang"]

    ;; toggle
    :t {:name :toggle

        :m [#(set vim.bo.modifiable (not vim.bo.modifiable)) :Modifiable]
        :l [#(set vim.o.list (not vim.o.list)) "List invisible chars"]
        :f [#(set nvim.g.neovide_fullscreen (not nvim.g.neovide_fullscreen)) "Full Screen"]
        :r [#(set vim.o.relativenumber (not vim.o.relativenumber)) "Relative Numbers"]
        :R [#(vim.cmd "e %") "Refresh file"]

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

;; language setup
(vim.cmd "lang en_US.UTF-8") ;; tmp fix until nvim 0.7.1 https://github.com/neovim/neovim/issues/5683#issuecomment-1114756116
(vim.api.nvim_command "set keymap=russian-jcukenmac")
(set nvim.o.iminsert 0)
(set nvim.o.imsearch 0)

;; showing tabs, spaces, end-of-lines
(set vim.o.listchars "eol:¬,space:·,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ")

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
