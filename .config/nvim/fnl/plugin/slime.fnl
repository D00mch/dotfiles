(module plugin.slime
  {require {nvim aniseed.nvim
            util util}})

(set nvim.g.slime_target "neovim")

(vim.api.nvim_command "xmap √ <Plug>SlimeRegionSend")
(vim.api.nvim_command "nmap <leader>ef <Plug>SlimeParagraphSend")
