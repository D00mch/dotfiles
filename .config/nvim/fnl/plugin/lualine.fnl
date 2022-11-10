(module plugin.lualine
  {autoload {lualine lualine
             icons nvim-web-devicons}})
 
(lualine.setup
  {:sections
   {:lualine_a []
    :lualine_c [{1 :filename :path 1}]}
   })

(icons.setup {})
