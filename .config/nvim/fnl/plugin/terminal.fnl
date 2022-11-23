(module plugin.terminal
  {require {nvim aniseed.nvim
             term toggleterm
             {: kset} util}})

(kset :x :<leader>q ":ToggleTermSendVisualSelection<cr>")
(kset :x :√         "<leader>v" {:remap true})
(kset :n :<leader>e "vip<leader>q" {:remap true})

(kset :t :<D-w> :<Esc>:q<Cr> {:remap true})

(term.setup
  {:size 30
   :open_mapping :<space>8
   :hide_numbers true
   :shade_terminals false
   :shading_factor 2
   ;:start_in_insert false
   :insert_mappings false
   :terminal_mappings false
   :direction :horizontal
   :persist_size true})

(set nvim.g.unception_open_buffer_in_new_tab true)
