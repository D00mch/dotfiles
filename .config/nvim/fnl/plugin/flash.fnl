(module plugin.flash
  {require {nvim aniseed.nvim
            flash flash
            config flash.config
            {: kset} util}})

; (kset [:n :x :o] :q flash.jump)

(def english "asdfghjklqwertyuiopzxcvbnm")
(def russian "фывапролджэйцукенгшщзхъячсмитьбю")

(flash.setup
  {:labels english
   :modes {:char {:enabled false}
           :treesitter {:enabled false}}})

; (tset config :labels russian)
; config.labels
