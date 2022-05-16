(module plugin.toggleterm
  {autoload {nvim aniseed.nvim
             {:m map} util
             translate translate}})

(map :n :<Leader>te "viw:Translate RU -source=EN<CR>")
(map :x :<Leader>te ":Translate RU -source=en<CR>")
(map :n :<Leader>tr "viw:Translate EN -source=RU<CR>")
(map :x :<Leader>tr ":Translate EN -source=RU<CR>")
