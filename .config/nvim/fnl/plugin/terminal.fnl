(module plugin.terminal
  {require {nvim aniseed.nvim
             term toggleterm
             {: kset} util}})

(kset :x :<leader>q ":ToggleTermSendVisualSelection<cr>")
(kset :x :√         "<leader>v" {:remap true})
(kset :n :<leader>e "vip<leader>q" {:remap true})

(kset :t :<D-w> "<C-\\><C-n>:q<Cr>" {:remap true})
(kset :t :<D-v> "<Esc>pa")
(kset :t "<D-Esc>" "<C-\\><C-n>")

(term.setup
  {:size 30
   :open_mapping :<space>8
   :hide_numbers true
   :shade_terminals false
   :shading_factor 2
   :start_in_insert true
   :insert_mappings false
   :terminal_mappings false
   :direction :horizontal
   :persist_size true})
