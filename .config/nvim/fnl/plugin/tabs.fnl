(module plugin.tabs
  {require {nvim aniseed.nvim
            bufferline bufferline
            {: kset} util}})

;; tabs
(kset [:t :n :x] "<D-.>" ":BufferLineCycleNext<Cr>") ;; karabiner: cmd <
(kset [:i :c] "<D-.>" "<Esc><D-.>" {:remap true})

(kset [:t :n :x] "<D-,>" ":BufferLineCyclePrev<Cr>") ;; karabiner: cmd >
(kset [:i :c] "<D-,>" "<Esc><D-,>" {:remap true})

(kset [:n :t] ">>" ":tabmove +1<cr>")
(kset [:n :t] "<<" ":tabmove -1<cr>")
; alt + t
(kset [:n :t :x] :† (fn [] (vim.cmd "tabnew\nStartify")))
(kset [:n :t :x] :<D-t> :† {:remap true})
; alt + shift + t; cmd + shift + t with karabiner
(kset [:n :t :x] :ˇ (fn [] (vim.cmd "Undoquit")))

(for [i 1 8]
  (kset :n (.. "<D-" i ">") (.. i :gt)))
(kset :n :<D-9> (fn [] (bufferline.go_to_buffer -1 true)))

(bufferline.setup
  {:options {:mode :tabs
             :numbers  :ordinal
             :separator_style :slant
             :enforce_regular_tabs true
             ;:indicator {:style :underline}
             :always_show_bufferline false}
   :highlights {:numbers_selected {:italic false}
                :buffer_selected {:bold true
                                  :italic false}}})
