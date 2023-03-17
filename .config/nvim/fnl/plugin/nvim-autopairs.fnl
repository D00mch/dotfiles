(module plugin.nvim-autopairs
  {require {npairs nvim-autopairs
            rule nvim-autopairs.rule
            conds nvim-autopairs.conds}})

(npairs.setup {:disable_filetype [:clojure :scheme :lisp :timl :fennel :janet :racket]})

; (defn override-for-lisp [p]
;   (npairs.remove_rule p)
;   (npairs.add_rules
;     [(let [r (rule p p)]
;        (r:with_pair (conds.not_filetypes ["clojure" "clojurescript" "fennel" "scheme"])))]))

; (override-for-lisp "'")
; (override-for-lisp "`")
