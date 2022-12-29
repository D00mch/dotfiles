(module plugin.tabs
  {require {nvim aniseed.nvim
            bufferline bufferline
            {: kset} util}})

;; tabs
(kset [:n :x] "<D-.>" ":BufferLineCycleNext<Cr>") ;; karabiner: cmd <
(kset [:i :c] "<D-.>" "<Esc><D-.>" {:remap true})
(kset :t "<D-.>" "<C-\\><C-n><D-.>" {:remap true})

(kset [:n :x] "<D-,>" ":BufferLineCyclePrev<Cr>") ;; karabiner: cmd >
(kset [:i :c] "<D-,>" "<Esc><D-,>" {:remap true})
(kset :t "<D-,>" "<C-\\><C-n><D-,>" {:remap true})

(kset [:n :t] ">>" ":BufferLineMoveNext<cr>")
(kset [:n :t] "<<" ":BufferLineMovePrev<cr>")
; (kset [:n :t] ">>" ":tabmove +1<cr>")
; (kset [:n :t] "<<" ":tabmove -1<cr>")

(kset [:n :t :x] :<M-t> #(vim.cmd "tabnew\nAlpha"))
(kset [:n :t :x] :<D-t> :<Leader><Space> {:remap true})
;(kset [:n :t :x] :<D-t> :† {:remap true})

(for [i 1 8]
  ;(kset :n (.. "<D-" i ">") (.. i :gt))
  (kset :n (.. "<D-" i ">") #(bufferline.go_to_buffer i true))
  )

(kset :n :<D-9> #(bufferline.go_to_buffer -1 true))

(bufferline.setup
  {:options {;:mode :tabs
             :numbers  :ordinal
             :separator_style :slant
             :enforce_regular_tabs true
             ;:indicator {:style :underline}
             ;:always_show_bufferline false
             }
   :highlights {:numbers_selected {:italic false}
                :buffer_selected {:bold true
                                  :italic false}}})
