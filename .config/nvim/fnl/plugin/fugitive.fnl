(module plugin.fugitive
  {require {nvim aniseed.nvim
            u aniseed.nvim.util
            util util}
   require-macros [macros]})

(vim.api.nvim_create_user_command
  :FugitiveToggle
  (fn [args]
    (let [current-dir (vim.fn.expand "%")
          in-git? (string.match current-dir ".*%.git/index")]
      (vim.api.nvim_command (if in-git? "q" "G"))))
  {:nargs :* :desc "Toggle git like in idea"})

(vim.api.nvim_command "set splitbelow")
(util.nmap :ª ":FugitiveToggle<cr>") ;; alt+9, (mapped to cmd+9 with karabiner) 
(util.m :i :ª "<Esc>ª" {:noremap false})
