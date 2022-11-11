(module plugin.lualine
  {autoload {lualine lualine
             icons nvim-web-devicons}})
 
(lualine.setup
  {:sections
   {:lualine_a [{1 :filename :path 1}]
    :lualine_b [:branch]
    :lualine_c []
    :lualine_x [:encoding :filetype]}})

(icons.setup {})
