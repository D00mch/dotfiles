(module plugin.slime
  {require {nvim aniseed.nvim
            util util}})

(set nvim.g.slime_target "neovim")

(vim.cmd "xmap √ <Plug>SlimeRegionSend")
(vim.cmd "nmap <leader>ef <Plug>SlimeParagraphSend")
