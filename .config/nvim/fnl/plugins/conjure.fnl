(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset} (autoload :config.util))

(fn toggle-log-mod []
  (set nvim.g.conjure#log#jump_to_latest#enabled
       (not nvim.g.conjure#log#jump_to_latest#enabled)))

(fn toggle-result-register []
  (set nvim.g.conjure#eval#result_register
       (if (= nvim.g.conjure#eval#result_register "*")
         "r"
         "*")))

[{1 :Olical/conjure
  :lazy true
  :ft [:clojure :fennel]
  :branch "main"
  :init (fn []
          (set nvim.g.conjure#log#wrap true)
          (set nvim.g.conjure#eval#result_register "r")
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
          (set nvim.g.conjure#client#clojure#nrepl#mapping#refresh_changed false)

          ;; for rust
          (set nvim.g.conjure#extract#tree_sitter#enabled true)

          ;; floating window
          ; (set nvim.g.conjure#log#hud#height 0.6)
          ; (set nvim.g.conjure#log#hud#width 0.7)
          (set nvim.g.conjure#log#jump_to_latest#enabled true)

          (kset :n :<Space>tl toggle-log-mod "conjure.log")
          (kset :n :<Space>to toggle-result-register "conjure.output")

          ;; unmap
          (set nvim.g.conjure#client#clojure#nrepl#mapping#disconnect false)
          (set nvim.g.conjure#client#clojure#nrepl#mapping#connect_port_file false)

          ;; RefactorDefine: to declare binding in repl, put cursor on val nam 
          (kset :n :<Leader>rd "mZ\"8yieW\"9yie:ConjureEval (def <c-r>8 <c-r>9)<cr>`Z" {:remap true})

          ;; racket
          (set nvim.g.conjure#client#racket#nrepl#eval#raw_out true)

          ;; chicken scheme
          (set nvim.g.conjure#client#scheme#stdio#command  "csi -quiet -:c")
          (set nvim.g.conjure#client#scheme#stdio#prompt_pattern "\n-#;%d-> ")

          )}]
