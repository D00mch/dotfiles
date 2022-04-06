(module plugin.sexp
  {require {nvim aniseed.nvim}})

(set nvim.g.sexp_filetypes "clojure,scheme,lisp,timl,fennel,janet")

(nvim.set_keymap :n :<space>ks "<Plug>(sexp_capture_next_element)" {:noremap true})

(nvim.set_keymap :n :<space>ks "<Plug>(sexp_capture_next_element)" {:noremap true})
(nvim.set_keymap :n :<space>kS "<Plug>(sexp_capture_prev_element)" {:noremap true})
(nvim.set_keymap :n :<C-j> "<Plug>(sexp_swap_list_forward)" {:noremap true})
(nvim.set_keymap :n :<C-k> "<Plug>(sexp_swap_list_backward)" {:noremap true})
(nvim.set_keymap :n :<C-h> "<Plug>(sexp_swap_element_backward)" {:noremap true})
(nvim.set_keymap :n :<C-l> "<Plug>(sexp_swap_element_forward)" {:noremap true})
(nvim.set_keymap :n :<Leader>c "<Plug>(sexp_move_to_prev_bracket)i#_<C-[>" {:noremap true})
