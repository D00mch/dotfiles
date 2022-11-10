(module plugin.lualine
  {autoload {lualine lualine
             icons nvim-web-devicons}})
 
(lualine.setup
  {:options
   {:icons_enabled true
    ;:theme :ayu
    }})

(icons.setup {})
