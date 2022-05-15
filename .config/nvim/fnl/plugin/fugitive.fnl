(module plugin.fugitive
  {require {nvim aniseed.nvim
            u aniseed.nvim.util
            util util}
   require-macros [macros]})

(defn fugitive-toggle []
  (let [current-dir (vim.fn.expand "%")
        in-git? (string.match current-dir ".*%.git/index")]
    (vim.api.nvim_command (if in-git? "q" "G"))))

(vim.api.nvim_command "set splitbelow")
(vim.keymap.set [:n :x :i] :ª fugitive-toggle) ;; alt+9, (mapped to cmd+9 with karabiner) 
(util.m :i :ª "<Esc>ª" {:noremap false})
