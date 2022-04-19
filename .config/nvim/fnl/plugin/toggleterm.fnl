(module plugin.toggleterm
  {autoload {nvim aniseed.nvim
             term toggleterm
             t    toggleterm.terminal}})

(term.setup 
  {:size 25
   :open_mapping "•" ; alt + 8 (cmd + 8 from karabinner)
   :hide_numbers true
   :shade_terminals true
   :shading_factor 2
   :insert_mappings true
   :terminal_mappings true
   :direction :horizontal
   :persist_size true})

