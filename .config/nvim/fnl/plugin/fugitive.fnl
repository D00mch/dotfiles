(module plugin.fugitive
  {require {nvim aniseed.nvim
            u aniseed.nvim.util
            util util}
   require-macros [macros]})

(defn toggle-git []
  (let [current-dir (vim.fn.expand "%")]
    (if (string.match current-dir ".*%.git/index")
      (vim.cmd "q")
      (vim.cmd "G"))))

(u.fn-bridge :FugitiveToggle :plugin.fugitive :toggle-git)

(vim.cmd "set splitbelow")
(util.nmap :ª ":call FugitiveToggle()<cr>") ;; alt+9, like in Idea (mapped to cmd+9 with karabiner) 
(util.m :i :ª "<Esc>ª" {:noremap false})
