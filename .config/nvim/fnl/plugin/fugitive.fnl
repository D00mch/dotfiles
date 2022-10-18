(module plugin.fugitive
  {require {nvim aniseed.nvim
            u aniseed.nvim.util
            util util}
   require-macros [macros]})

(defn fugitive-toggle []
  (let [current-dir (vim.fn.expand "%") ;; :echo expand('%:p')
        in-git? (string.match current-dir "^fugitive://")]
    (vim.api.nvim_command (if in-git? "q" "G"))))

(defn annotate-toggle []
  (let [current-dir (vim.fn.expand "%")
        in-annotate? (string.match current-dir "fugitiveblame$")]
    (vim.api.nvim_command (if in-annotate? "q" "G blame"))))

(vim.api.nvim_command "set splitbelow")
(vim.keymap.set [:n :x :i] :ª fugitive-toggle) ;; alt+9, (mapped to cmd+9 with karabiner) 
(vim.keymap.set [:n :x :i] :<space>ga annotate-toggle)
(util.m :i :ª "<Esc>ª" {:noremap false})
