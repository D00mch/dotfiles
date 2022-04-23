(module plugin.lightspeed
  {require {nvim aniseed.nvim
            util util}})

; unmapping default search mappings
(util.map :s :s)
(util.map :S :S)

(nvim.set_keymap "" "q" "<Plug>Lightspeed_s" {:noremap false})
(nvim.set_keymap "" "Q" "<Plug>Lightspeed_S" {:noremap false})
(nvim.set_keymap "" "gq" "<Plug>Lightspeed_gs" {:noremap false})
(nvim.set_keymap "" "gQ" "<Plug>Lightspeed_gS" {:noremap false})