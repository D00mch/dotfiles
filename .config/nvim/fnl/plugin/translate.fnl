(module plugin.translate
  {autoload {nvim aniseed.nvim
             {: kset} util
             translate translate}})

(translate.setup
  {:default {:command :google}
   :preset {:output
            {:register
             {:name "*"}}}})

(kset :x :<Space>r ":Translate RU -source=en<CR>")
(kset :x :<Space>e ":Translate EN<CR>")

(kset :x :<Space>R ":Translate RU -source=EN -output=register<CR>")
(kset :x :<Space>E ":Translate EN -output=register<CR>")
