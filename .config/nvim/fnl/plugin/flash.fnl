(module plugin.flash
  {require {nvim aniseed.nvim
            flash flash
            config flash.config
            {: kset} util}})

(kset [:n :x :o] :q flash.jump)

(def english "asdfghjklqwertyuiopzxcvbnm")
(def russian "фывапролджэйцукенгшщзхъячсмитьбю")

(flash.setup
  {:labels english
   :modes {:char {:enabled false}
           :search {:enabled false}
           :treesitter {:enabled false}}
   :label {:uppercase false
           :rainbow {:enabled false
                     :shade 5}
           :after false
           :before true
           :style :inline}})

; (tset config :labels russian)
; config.labels
