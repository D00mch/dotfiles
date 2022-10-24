(module plugin.sexp
  {require {nvim aniseed.nvim
            {: toggle} plugin.which
            {: kset} util}})

(set nvim.g.sexp_filetypes "*")
(set nvim.g.sexp_enable_insert_mode_mappings 1)
(set nvim.g.sexp_insert_after_wrap 0) ;do not insert spaces

(set nvim.g.sexp_mappings {:sexp_capture_next_element  :<space>ks
                           :sexp_capture_prev_element  :<space>kS
                           :sexp_emit_tail_element     :<space>kb
                           :sexp_emit_head_element     :<space>kB

                           :sexp_move_to_prev_bracket  "{"
                           :sexp_move_to_next_bracket  "}"

                           ;; move
                           :sexp_move_to_next_element_tail :<space>mr
                           :sexp_move_to_prev_element_tail :<space>ml
                           :sexp_move_to_next_top_element :<space>mb
                           :sexp_move_to_prev_top_element :<space>mh

                           ;; disabled keys
                           :sexp_indent                ""
                           :sexp_indent_top            ""
                           :sexp_round_tail_wrap_list  ""
                           :sexp_round_head_wrap_list  ""

                           ;; move element under cursor
                           :sexp_swap_list_forward     :<C-j>
                           :sexp_swap_list_backward    :<C-k>
                           :sexp_swap_element_backward :<C-h>
                           :sexp_swap_element_forward  :<C-l>})

(kset :n :<Leader>c :gcaf)
