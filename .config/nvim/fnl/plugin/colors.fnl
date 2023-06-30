(module plugin.colors
  {autoload {nvim aniseed.nvim
             colorizer colorizer
             {: kset} util
             {: first} aniseed.core}})

(colorizer.setup)

(kset :n :<Space>cc ":ColorizerToggle<Cr>")
