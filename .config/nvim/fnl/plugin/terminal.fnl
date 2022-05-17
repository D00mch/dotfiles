(module plugin.terminal
  {require {nvim aniseed.nvim
             term toggleterm
             {:m map} util}})

(defn update-bg []
  (set nvim.o.background nvim.o.background)
  (vim.api.nvim_command (.. "colorscheme " nvim.g.colors_name)))

(map :x :√ ":ToggleTermSendVisualSelection<cr>")

(term.setup 
  {:size 30
   :open_mapping "•" ; alt + 8 (cmd + 8 from karabinner)
   :hide_numbers true
   :shade_terminals false
   :shading_factor 2
   :on_open update-bg
   ;:start_in_insert false
   :insert_mappings true
   :terminal_mappings true
   :direction :horizontal
   :persist_size true})
