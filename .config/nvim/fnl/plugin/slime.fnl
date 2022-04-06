(module plugin.slime
  {require {nvim aniseed.nvim
            u util}})

(def- map u.m)

(set nvim.g.slime_target :neovim)

(map :x "√" "<Plug>SlimeRegionSend")
(map :n "<leader>ef" "<Plug>SlimeParagraphSend")

(map :n "<leader>bb" ":ls<cr>")

echo 1
