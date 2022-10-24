(module plugin.terminal
  {require {nvim aniseed.nvim
             term toggleterm
             {: kset} util}})

(kset :x :<leader>q ":ToggleTermSendVisualSelection<cr>")
(kset :x :√         "<leader>v" {:noremap false})
(kset :n :<leader>f "vip<leader>q" {:noremap false})

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
