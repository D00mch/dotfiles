(module plugin.lightspeed
  {require {nvim aniseed.nvim
            {:m map :map remap} util}})

; unmapping default search mappings
(remap :s :s)
(remap :S :S)

(map "" "q" "<Plug>Lightspeed_s" {:noremap false})
(map "" "Q" "<Plug>Lightspeed_S" {:noremap false})
(map "" "gq" "<Plug>Lightspeed_gs" {:noremap false})
(map "" "gQ" "<Plug>Lightspeed_gS" {:noremap false})
