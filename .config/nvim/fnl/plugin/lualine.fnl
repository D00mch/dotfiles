(module plugin.lualine)

(let [(ok? lualine) (pcall require :lualine)]
  (when ok?
    (lualine.setup 
      {:options 
       {:icons_enabled true
        ;:theme :ayu
        }})))
