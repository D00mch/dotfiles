(module plugin.conjure
  {require {nvim aniseed.nvim
            u util}})

(set nvim.g.conjure#log#wrap true)
(set nvim.g.conjure#eval#result_register "*")
(set nvim.g.conjure#log#botright true)
;(set nvim.g.conjure#mapping#doc_word "hh") ; K by default
(set nvim.g.conjure#mapping#eval_visual "v")
(set nvim.g.conjure#mapping#eval_file "b")
(set nvim.g.conjure#mapping#eval_root_form "f")
(set nvim.g.conjure#mapping#eval_current_form "ee")
(set nvim.g.conjure#mapping#eval_comment_current_form "es")
(set nvim.g.conjure#extract#tree_sitter#enabled true)
(set nvim.g.conjure#client#clojure#nrepl#eval#raw_out true)
(set nvim.g.conjure#eval#inline#prefix "| ")

;; floating window size
; (set nvim.g.conjure#log#hud#height 0.6)
; (set nvim.g.conjure#log#hud#width 0.7)

;; unmap
(set nvim.g.conjure#client#clojure#nrepl#mapping#disconnect false)
(set nvim.g.conjure#client#clojure#nrepl#mapping#connect_port_file false)

;; RefactorDefine: to declare binding in repl, put cursor on val name  
(u.m :n :<Leader>rd "vie<space>mr\"9y:ConjureEval (def <c-r>9)<cr>" {:noremap false})

;; tests
; (set nvim.g.conjure#client#clojure#nrepl#mapping#run_current_ns_tests false)
; (set nvim.g.conjure#client#clojure#nrepl#mapping#run_alternate_ns_tests false)
; (set nvim.g.conjure#client#clojure#nrepl#mapping#run_current_test false)
; (set nvim.g.conjure#client#clojure#nrepl#mapping#run_all_tests false)

;; racket
(set nvim.g.conjure#client#racket#nrepl#eval#raw_out true)

;; chicken scheme
(set nvim.g.conjure#client#scheme#stdio#command  "csi -quiet -:c")
(set nvim.g.conjure#client#scheme#stdio#prompt_pattern "\n-#;%d-> ")
