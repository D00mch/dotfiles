(module plugin.tabs
  {require {nvim aniseed.nvim
            bufferline bufferline
            {: kset} util}})

(kset [:i :t :n] :<C-y> ::BufferLineCycleNext<CR> ) 
(kset [:i :t :n] :<C-t> ::BufferLineCyclePrev<CR>  ) 
(kset [:t :n] ">>" ::BufferLineMoveNext<CR> ) 
(kset [:t :n] "<<" ::BufferLineMovePrev<CR> ) 
(kset [:n :t :x :i] :† ::Startify<cr>) 

(for [i 1 8]
  (kset :n (.. :<leader> i) (.. ":BufferLineGoToBuffer " i :<Cr>)))
(kset :n  :<leader>9 ":BufferLineGoToBuffer -1<CR>")

(bufferline.setup
  {:options {:numbers  :ordinal
             ;:indicator {:style :underline}
             :always_show_bufferline false}
   :highlights {:buffer_selected {:bold true
                                  :italic false}}})
