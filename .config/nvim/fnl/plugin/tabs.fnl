(module plugin.tabs
  {require {nvim aniseed.nvim
            bufferline bufferline
            {: kset} util}})

;; tabs
(kset [:i :t :n] :<C-y> :<Esc>gt) ;; karabiner: cmd <
(kset [:i :t :n] :<C-t> :<Esc>gT) ;; karabiner: cmd >
(kset [:n :t] ">>" ":tabmove +1<cr>")
(kset [:n :t] "<<" ":tabmove -1<cr>")
; alt + t; cmd + t with karabiner
(kset [:n :t :x] :† (fn [] (vim.cmd "tabnew\nStartify")))
; alt + shift + t; cmd + shift + t with karabiner
(kset [:n :t :x] :ˇ (fn [] (vim.cmd "Undoquit")))

(for [i 1 8]
  (kset :n (.. :<leader> i) (.. i :gt)))
(kset :n :<leader>9 (fn [] (bufferline.go_to_buffer -1 true)))

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
