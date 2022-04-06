(module plugin.sexp
  {require {nvim aniseed.nvim
            u util}})

(set nvim.g.sexp_filetypes "clojure,scheme,lisp,timl,fennel,janet")

(nvim.set_keymap :n :<space>ks "<Plug>(sexp_capture_next_element)" {:noremap true})

(u.map :<space>ks "<Plug>(sexp_capture_next_element)")
(u.map :<space>kS "<Plug>(sexp_capture_prev_element)")
(u.map :<C-j> "<Plug>(sexp_swap_list_forward)")
(u.map :<C-k> "<Plug>(sexp_swap_list_backward)")
(u.map :<C-h> "<Plug>(sexp_swap_element_backward)")
(u.map :<C-l> "<Plug>(sexp_swap_element_forward)")
(u.map :<Leader>c "<Plug>(sexp_move_to_prev_bracket)i#_<C-[>" )
