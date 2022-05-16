(module plugin.conjure
  {require {nvim aniseed.nvim}})

(set nvim.g.conjure#log#wrap true)
(set nvim.g.conjure#eval#result_register "*")
(set nvim.g.conjure#log#botright true)
(set nvim.g.conjure#mapping#doc_word "hh")
(set nvim.g.conjure#mapping#eval_visual "ev")
(set nvim.g.conjure#mapping#eval_file "eb")
(set nvim.g.conjure#mapping#eval_root_form "ef")
(set nvim.g.conjure#mapping#eval_comment_current_form "sf")
(set nvim.g.conjure#extract#tree_sitter#enabled true)

;; unmap
(set nvim.g.conjure#client#clojure#nrepl#mapping#disconnect false)
(set nvim.g.conjure#client#clojure#nrepl#mapping#connect_port_file false)

;; unmap tests
(set nvim.g.conjure#client#clojure#nrepl#mapping#run_current_ns_tests false)
(set nvim.g.conjure#client#clojure#nrepl#mapping#run_alternate_ns_tests false)
(set nvim.g.conjure#client#clojure#nrepl#mapping#run_current_test false)
(set nvim.g.conjure#client#clojure#nrepl#mapping#run_all_tests false)
