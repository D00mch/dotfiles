(module plugin.lualine
  {autoload {lualine lualine
             icons nvim-web-devicons}})
 
(lualine.setup
  {:sections
   {:lualine_b [{1 :filename :path 1}]
    :lualine_a [:branch]
    :lualine_c []
    :lualine_x [:encoding :filetype]}})

(icons.setup {})
