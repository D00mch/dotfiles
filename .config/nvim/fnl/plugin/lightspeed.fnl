(module plugin.lightspeed
  {require {nvim aniseed.nvim
            util util}})

; unmapping default search mappings
(util.map :s :s)
(util.map :S :S)

(nvim.set_keymap "" "<space>j" "<Plug>Lightspeed_s" {:noremap false})
