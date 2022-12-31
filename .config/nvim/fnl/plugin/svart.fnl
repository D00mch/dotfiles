(module plugin.svart
  {require {nvim aniseed.nvim
            svart svart
            {: kset} util}})

(kset [:n :x :o] :q "<Cmd>Svart<CR>")
(kset [:n :x :o] :Q "<Cmd>SvartRegex<CR>")
;(kset [:n :o] :gq "<Cmd>SvartRepeat<CR>")

(svart.configure
  {})
