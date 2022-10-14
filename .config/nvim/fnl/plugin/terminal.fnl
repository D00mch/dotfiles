(module plugin.terminal
  {require {nvim aniseed.nvim
             term toggleterm
             {:map map :m m} util}})

(m :x :√ ":ToggleTermSendVisualSelection<cr>")
(map :<leader>ee "vip√")

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
