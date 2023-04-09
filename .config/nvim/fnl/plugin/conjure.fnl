(module plugin.conjure
  {require {nvim aniseed.nvim
            {: kset} util}})

(set nvim.g.conjure#log#wrap true)
(set nvim.g.conjure#eval#result_register "*")
(set nvim.g.conjure#log#botright true)
;(set nvim.g.conjure#mapping#doc_word "hh") ; K by default
(set nvim.g.conjure#extract#tree_sitter#enabled true)
(set nvim.g.conjure#client#clojure#nrepl#eval#raw_out true)
(set nvim.g.conjure#eval#inline#prefix "| ")

;; eval
(set nvim.g.conjure#mapping#eval_visual "q")
(set nvim.g.conjure#mapping#eval_buf "b")
(set nvim.g.conjure#mapping#eval_root_form "e")
(set nvim.g.conjure#mapping#eval_word "w")
(set nvim.g.conjure#mapping#eval_marked_form "m")
(set nvim.g.conjure#mapping#eval_current_form "q")
(set nvim.g.conjure#mapping#eval_comment_current_form ";")
(set nvim.g.conjure#client#clojure#nrepl#mapping#interrupt "i")
(set nvim.g.conjure#mapping#eval_file false)
(set nvim.g.conjure#mapping#eval_replace_form false)
(set nvim.g.conjure#mapping#eval_comment_word false)
(set nvim.g.conjure#mapping#eval_comment_root_form false)
(set nvim.g.conjure#client#clojure#nrepl#mapping#refresh_all false)

(kset [:n :x :i] :<D-l> "<Leader>lg" {:remap true})

;; floating window size
; (set nvim.g.conjure#log#hud#height 0.6)
; (set nvim.g.conjure#log#hud#width 0.7)

;; unmap
(set nvim.g.conjure#client#clojure#nrepl#mapping#disconnect false)
(set nvim.g.conjure#client#clojure#nrepl#mapping#connect_port_file false)

;; RefactorDefine: to declare binding in repl, put cursor on val nam 
(kset :n :<Leader>rd "mZ\"8yieW\"9yie:ConjureEval (def <c-r>8 <c-r>9)<cr>`Z" {:remap true})

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
