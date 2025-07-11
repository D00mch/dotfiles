(local {: kset} (require :config.util))
(kset :n :<Space>i #((. (require :toggleterm) :toggle)))

[{1 :akinsho/toggleterm.nvim
  :lazy true
  :cmd [:ToggleTerm :ToggleTermSendVisualSelection]
  :init (fn []
          (let [{: kset} (require :config.util)]
            (kset :x :<leader>q ":ToggleTermSendVisualSelection<cr>")
            (kset :x :√         "<leader>v" {:remap true})
            (kset :n :<leader>e "vip<leader>q" {:remap true})
            (kset :t :<D-w> "<C-\\><C-n>:hide<Cr>" {:remap true})
            (kset :t :<D-v> "<Esc>pa")
            (kset :t "<D-Esc>" "<C-\\><C-n>")
            (kset :t :<D-c> :<C-c>)))
  :config (fn []
            (let [term (require :toggleterm)]
              (term.setup
                {:size 20
                 :on_open (fn [t]
                            (if (= (vim.fn.mode) "n")
                              (vim.cmd "startinsert!")))
                 :open_mapping :<space>i
                 :hide_numbers true
                 :shade_terminals false
                 :shading_factor 2
                 :start_in_insert true
                 :insert_mappings false
                 :terminal_mappings false
                 :direction :horizontal
                 :persist_size true})))}]
