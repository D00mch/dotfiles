(module plugin.toggleterm
  {autoload {nvim aniseed.nvim
             {: kset} util
             translate translate}})

(kset :n :<Space>te "viw:Translate RU -source=EN<CR>")
(kset :x :<Space>te ":Translate RU -source=en<CR>")
(kset :n :<Space>tr "viw:Translate EN -source=RU<CR>")
(kset :x :<Space>tr ":Translate EN -source=RU<CR>")
