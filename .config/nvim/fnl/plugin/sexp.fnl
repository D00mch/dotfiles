(module plugin.sexp
  {require {nvim aniseed.nvim
            u util}})

(set nvim.g.sexp_filetypes "clojure,scheme,lisp,timl,fennel,janet,markdown")
(set nvim.g.sexp_enable_insert_mode_mappings 0) ;set up with auto-pairs
(set nvim.g.sexp_insert_after_wrap 0) ;do not insert spaces

(nvim.set_keymap :n :<space>ks "<Plug>(sexp_capture_next_element)" {:noremap true})

;; RefactorDefine: to declare binding in repl, put cursor on val name  
(u.m :n :<Leader>rd "vie<space>mr\"9y:ConjureEval (def <c-r>9)<cr>" {:noremap false})

(set nvim.g.sexp_mappings {:sexp_capture_next_element  :<space>ks
                           :sexp_capture_prev_element  :<space>kS
                           :sexp_emit_tail_element     :<space>kb 
                           :sexp_emit_head_element     :<space>kB 

                           ;; move
                           :sexp_move_to_next_element_tail :<space>mr
                           :sexp_move_to_prev_element_tail :<space>ml
                           :sexp_move_to_next_top_element :<space>mb
                           :sexp_move_to_prev_top_element :<space>mh

                           ;; disabled keys
                           :sexp_indent                ""
                           :sexp_indent_top            ""

                           ;; move element under cursor
                           :sexp_swap_list_forward     :<C-j> 
                           :sexp_swap_list_backward    :<C-k> 
                           :sexp_swap_element_backward :<C-h> 
                           :sexp_swap_element_forward  :<C-l>})

(u.map :<Leader>c :gcaf)
