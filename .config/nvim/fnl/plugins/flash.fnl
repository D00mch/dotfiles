(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))

(local english "asdfghjklqwertyuiopzxcvbnm")
; (local russian "фывапролджэйцукенгшщзхъячсмитьбю")

[{1 :folke/flash.nvim
  :lazy true
  :init (fn []
          (let [flash (require :flash)]
            (kset [:n :x :o] :q flash.jump)))
  :opts {:labels english
         :modes {:char {:enabled false}
                 :search {:enabled true
                          :incremental true}
                 :treesitter {:enabled false}}
         :label {:uppercase false
                 :rainbow {:enabled false
                           :shade 5}
                 :after false
                 :before true
                 :style :inline}}
  :config true}]
