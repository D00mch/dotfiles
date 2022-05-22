(module plugin.terminal
  {require {nvim aniseed.nvim
             term toggleterm
             {:m map} util}})

(map :x :√ ":ToggleTermSendVisualSelection<cr>")

(term.setup 
  {:size 30
   :open_mapping "•" ; alt + 8 (cmd + 8 from karabinner)
   :hide_numbers true
   :shade_terminals false
   :shading_factor 2
   ;:start_in_insert false
   :insert_mappings true
   :terminal_mappings true
   :direction :horizontal
   :persist_size true})
