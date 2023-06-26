(module plugin.flash
  {require {nvim aniseed.nvim
            flash flash
            {: kset} util}})

(kset [:n :x :o] :q flash.jump)

(flash.setup
  {:modes {:char {:enabled false}
           :treesitter {:enabled false}}})
