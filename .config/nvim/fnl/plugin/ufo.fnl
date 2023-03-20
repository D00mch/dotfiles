(module plugin.ufo
  {require {nvim aniseed.nvim
            ufo ufo
            {: kset} util}})

(ufo.setup)

(kset :n :zM ufo.closeAllFolds)
