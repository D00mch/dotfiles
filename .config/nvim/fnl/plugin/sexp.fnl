(module plugin.sexp
  {require {nvim aniseed.nvim
            u util}})

(set nvim.g.sexp_filetypes "clojure,scheme,lisp,timl,fennel,janet")
(set nvim.g.sexp_enable_insert_mode_mappings 0) ;parinfer does this better
(set nvim.g.sexp_insert_after_wrap 0) ;do not insert spaces

(nvim.set_keymap :n :<space>ks "<Plug>(sexp_capture_next_element)" {:noremap true})

(u.map :<space>ks "<Plug>(sexp_capture_next_element)")
(u.map :<space>kS "<Plug>(sexp_capture_prev_element)")
(u.map :<space>kb "<Plug>(sexp_emit_tail_element)")
(u.map :<space>kB "<Plug>(sexp_emit_head_element)")
(u.map :<C-j> "<Plug>(sexp_swap_list_forward)")
(u.map :<C-k> "<Plug>(sexp_swap_list_backward)")
(u.map :<C-h> "<Plug>(sexp_swap_element_backward)")
(u.map :<C-l> "<Plug>(sexp_swap_element_forward)")
(u.map :<Leader>c "<Plug>(sexp_move_to_prev_bracket)i#_<C-[>")

;; map form objects
(u.m :o "o" "af" {:noremap false})
(u.m :x "o" "af" {:noremap false})
(u.m :o "io" "if" {:noremap false})
(u.m :x "io" "if" {:noremap false})
