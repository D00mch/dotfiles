(module plugin.sexp
  {require {nvim aniseed.nvim
            u util}})

(set nvim.g.sexp_filetypes "clojure,scheme,lisp,timl,fennel,janet")

(nvim.set_keymap :n :<space>ks "<Plug>(sexp_capture_next_element)" {:noremap true})

(u.nnoremap :<space>ks "<Plug>(sexp_capture_next_element)")
(u.nnoremap :<space>kS "<Plug>(sexp_capture_prev_element)")
(u.nnoremap :<C-j> "<Plug>(sexp_swap_list_forward)")
(u.nnoremap :<C-k> "<Plug>(sexp_swap_list_backward)")
(u.nnoremap :<C-h> "<Plug>(sexp_swap_element_backward)")
(u.nnoremap :<C-l> "<Plug>(sexp_swap_element_forward)")
(u.nnoremap :<Leader>c "<Plug>(sexp_move_to_prev_bracket)i#_<C-[>" )
