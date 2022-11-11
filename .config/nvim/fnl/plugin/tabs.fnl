(module plugin.tabs
  {require {nvim aniseed.nvim
            bufferline bufferline
            {: kset} util}})

(kset [:i :t :n] :<C-y> ::BufferLineCycleNext<CR> ) 
(kset [:i :t :n] :<C-t> ::BufferLineCyclePrev<CR>  ) 
(kset [:t :n] ">>" ::BufferLineMoveNext<CR> ) 
(kset [:t :n] "<<" ::BufferLineMovePrev<CR> ) 
(kset [:n :t :x :i] :† ::Startify<cr>) 

(kset :n  :<leader>1 ":BufferLineGoToBuffer 1<CR>")
(kset :n  :<leader>2 ":BufferLineGoToBuffer 2<CR>")
(kset :n  :<leader>3 ":BufferLineGoToBuffer 3<CR>")
(kset :n  :<leader>4 ":BufferLineGoToBuffer 4<CR>")
(kset :n  :<leader>5 ":BufferLineGoToBuffer 5<CR>")
(kset :n  :<leader>6 ":BufferLineGoToBuffer 6<CR>")
(kset :n  :<leader>7 ":BufferLineGoToBuffer 7<CR>")
(kset :n  :<leader>8 ":BufferLineGoToBuffer 8<CR>")
(kset :n  :<leader>9 ":BufferLineGoToBuffer -1<CR>")

(bufferline.setup
  {:options {:numbers  :ordinal
             ;:indicator {:style :underline}
             :always_show_bufferline false}
   :highlights {:buffer_selected {:bold true
                                  :italic false}}})
