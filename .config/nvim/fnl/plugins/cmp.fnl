(local {: autoload} (require :nfnl.module))
(local {: merge} (autoload :nfnl.core))
(local telescope (autoload :telescope))

(local cmp-src-menu-items
  {:buffer "buff"
   :conjure "conj"
   ; :copilot "copilot"
   :path "path"
   :nvim_lsp "lsp"})

(local cmp-srcs
  [{:name :nvim_lsp}
   {:name :conjure}
   {:name :buffer}
   {:name :path}
   {:name :spell}
   ; {:name :copilot}
   {:name :codeium}
   {:name :snippy}])

(fn has-words-before []
  (let [[line col] (vim.api.nvim_win_get_cursor 0)]
    (and (~= col 0)
         (let [line (vim.api.nvim_get_current_line)
               behind (line:sub col col)]
           (= (behind:match "%s") nil)))))

[{1 :hrsh7th/nvim-cmp
  :dependencies [:hrsh7th/cmp-buffer 
  :hrsh7th/cmp-nvim-lsp 
  :hrsh7th/cmp-path 
  :hrsh7th/cmp-cmdline 
  :f3fora/cmp-spell 
  :PaterJason/cmp-conjure 
  :dcampos/cmp-snippy
  :dcampos/nvim-snippy
                 ]
  :config (fn []
            (let [cmp (require :cmp)
                  snippy (require :snippy)

                  snippy-tab (fn  [fallback]
                               (if
                                 (cmp.visible)
                                 (cmp.select_next_item)

                                 (snippy.can_expand_or_advance)
                                 (snippy.expand_or_advance)

                                 (has-words-before)
                                 (cmp.complete)

                                 (fallback)))]

              (cmp.setup
                {:formatting
                 {:format (fn [entry item]
                            (set item.menu (or (. cmp-src-menu-items entry.source.name) ""))
                            item)}
                 ; :formatters 
                 ; {:insert_text copilot-format.remove_existing}

                 :preselect
                 cmp.PreselectMode.None

                 :complete {:completeopt "menu,menuone"}

                 :mapping
                 {:<Tab> (cmp.mapping snippy-tab [:i :s])
                  :<S-Tab> (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Select})
                  :<down> (cmp.mapping.select_next_item {:behavior cmp.SelectBehavior.Select})
                  :<up> (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Select})
                  :<left> (cmp.mapping (cmp.mapping.scroll_docs -4) [:i :c])
                  :<right> (cmp.mapping (cmp.mapping.scroll_docs 4) [:i :c])
                  :<C-Space> (cmp.mapping.complete)
                  :<C-e> (cmp.mapping.close)
                  :<CR> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace
                                              :select false})}
                 :sources cmp-srcs
                 :confirm_opts {:behavior cmp.ConfirmBehavior.Replace
                                :select false}
                 :snippet
                 {:expand (fn [args] (snippy.expand_snippet args.body))}})


                (cmp.setup.cmdline 
                  "/"
                  {:mapping (cmp.mapping.preset.cmdline)
                   :sources (cmp.config.sources [{:name :buffer :max_item_count 18}])})

                (cmp.setup.cmdline
                  ":"
                  {:mapping (cmp.mapping.preset.cmdline)
                   :sources (cmp.config.sources [{:name :cmdline :max_item_count 18}
                                                 {:name :path :max_item_count 12}])})))}]
