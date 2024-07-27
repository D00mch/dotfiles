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

(kset :n :g? #(wk.show {:global false}))

;; language setup
(vim.api.nvim_command "set keymap=russian-jcukenwin")
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

;; language
(kset :n :<Space>e 
      (.. "<Cmd>" (set-lang-cmd "en_US") "setlocal spell! spelllang=ru_ru,en_us<cr>") 
      "Set ENG, toggle grammar")
(kset :n :<Space>r
      (.. "<Cmd>" (set-lang-cmd "ru_RU") "setlocal spell! spelllang=ru_ru,en_us<cr>")
      "Set RUS, toggle grammar")

;; key setup
(wk.add {1 :<space>t    :group :Toggle})
(wk.add {1 :<space>ta   :group :Animation})
(wk.add {1 :<space>f    :group :Format     :mode [:x :v]})
(wk.add {1 :<space>fb   :group :Base64     :mode [:x :v]})

;; toggles
(kset :n :<space>tm #(set vim.bo.modifiable (not vim.bo.modifiable)) :Modifiable)
(kset :n :<space>ti #(set vim.o.list (not vim.o.list)) "List invisible chars")
(kset :n :<space>tf #(set nvim.g.neovide_fullscreen (not nvim.g.neovide_fullscreen)) "Full screen")
(kset :n :<space>tr #(set vim.o.relativenumber (not vim.o.relativenumber)) "Relative Numbers")
(kset :n :<space>tR "mZ:Bd!<cr>`Z"  "Refresh file")

;; animations
(kset :n :<space>ta1 "<cmd>CellularAutomaton make_it_rain<CR>" :Rain)
(kset :n :<space>ta2 "<cmd>CellularAutomaton game_of_life<CR>" :Game)
(kset :n :<space>ta3 "<cmd>CellularAutomaton scramble<CR>" :Scramble)

;; formatters
(kset :x :<space>fj :!jq<cr> "Json")
(kset :x :<space>fp "!pg_format -s 2<cr>" "pSQL")
(kset :x :<space>fc "<Esc>:ReplaceSelection tocamel<Cr>" "CamelCase")
(kset :x :<space>fs "<Esc>:ReplaceSelection tosnake<Cr>" "snake_case")         
(kset :x :<space>fk "<Esc>:ReplaceSelection tokebab<Cr>" "kebab-case")
(kset :x :<space>f8 "<Esc>:set tw=80<Cr>gvgq" "80 width")

(kset :x :<space>fbe "c<c-r>=system('base64', @\")[:-2]<cr><c-\\><c-n>" "Encode")
(kset :x :<space>fbd "c<c-r>=system('base64 --decode', @\")[:-1]<cr><c-\\><c-n>" "Decode")

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
