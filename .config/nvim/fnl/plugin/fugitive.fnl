(module plugin.fugitive
  {require {nvim aniseed.nvim
            util util}})

(vim.cmd "set splitbelow")
(util.nmap :ª ":G<cr>") ;; alt+9, like in Idea (mapped to cmd+9 with karabiner) 
(util.m :i :ª "<Esc>ª" {:noremap false})
