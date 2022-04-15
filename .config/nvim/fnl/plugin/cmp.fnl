(module plugin.cmp
  {autoload {nvim aniseed.nvim
             cmp cmp
             luasnip luasnip}})

(def- cmp-src-menu-items
  {:buffer "buff"
   :conjure "conj"
   :cmdline "cmdline"
   :path "path"
   :nvim_lsp "lsp"})

(def- cmp-srcs
  [{:name :nvim_lsp}
   {:name :conjure}
   {:name :buffer}
   {:name :path}
   {:name :cmdline}
   {:name :luasnip}])

(defn luasnip-tab [fallback]
  (if 
    (cmp.visible)
    (cmp.select_next_item {:behavior cmp.SelectBehavior.Select})
    
    (luasnip.expand_or_jumpable)
    (vim.fn.feedkeys 
      (vim.api.nvim_replace_termcodes 
        "<Plug>luasnip-expand-or-jump" true true true) 
      "")
    
    (fallback)))

;; Setup cmp with desired settings
(cmp.setup {:formatting
            {:format (fn [entry item]
                       (set item.menu (or (. cmp-src-menu-items entry.source.name) ""))
                       item)}

            :mapping {:<Tab> luasnip-tab
                      :<S-Tab> (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Select})
                      :<down> (cmp.mapping.select_next_item {:behavior cmp.SelectBehavior.Select})
                      :<up> (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Select})
                      :<C-Space> (cmp.mapping.complete)
                      :<C-e> (cmp.mapping.close)
                      :<CR> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace
                                                  :select true})}
            :sources cmp-srcs
            :confirm_opts {:behavior cmp.ConfirmBehavior.Replace
                           :select false}
            :snippet {:expand (fn [args] (luasnip.lsp_expand args.body))}})

(cmp.setup.cmdline "/" {:mapping (cmp.mapping.preset.cmdline)}
                        :sources [{:name :buffer}])

(cmp.setup.cmdline ":" {:mapping (cmp.mapping.preset.cmdline)
                        :sources (cmp.config.sources [{:name :cmdline} 
                                                      {:name :path}])})
