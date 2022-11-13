(module plugin.toggleterm
  {autoload {nvim aniseed.nvim
             {: kset} util
             translate translate}})

(kset :x :<Space>e ":Translate RU -source=en<CR>")
(kset :x :<Space>r ":Translate EN -source=RU<CR>")
