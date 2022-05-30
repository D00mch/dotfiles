(module plugin.toggleterm
  {autoload {nvim aniseed.nvim
             {:m map} util
             translate translate}})

(map :n :<Space>te "viw:Translate RU -source=EN<CR>")
(map :x :<Space>te ":Translate RU -source=en<CR>")
(map :n :<Space>tr "viw:Translate EN -source=RU<CR>")
(map :x :<Space>tr ":Translate EN -source=RU<CR>")
