(module plugin.cmp
  {autoload {nvim aniseed.nvim
             {: first} aniseed.core
             ; copilot-format copilot_cmp.format
             cmp cmp
             snippy snippy}})

(def- cmp-src-menu-items
  {:buffer "buff"
   :conjure "conj"
   ; :copilot "copilot"
   :path "path"
   :nvim_lsp "lsp"})

(def- cmp-srcs
  [{:name :nvim_lsp}
   {:name :conjure}
   {:name :buffer}
   {:name :path}
   {:name :spell}
   ; {:name :copilot}
   {:name :snippy}])

;; snippy tab

(defn has-words-before []
  (let [[line col] (vim.api.nvim_win_get_cursor 0)]
    (and (~= col 0)
         (let [line (vim.api.nvim_get_current_line)
               behind (line:sub col col)]
           (= (behind:match "%s") nil)))))

(defn snippy-tab [fallback]
  (if
    (cmp.visible)
    (cmp.select_next_item)

    (snippy.can_expand_or_advance)
    (snippy.expand_or_advance)

    (has-words-before)
    (cmp.complete)

    (fallback)))

;; Setup cmp with desired settings
(cmp.setup
  {:formatting
   {:format (fn [entry item]
              (set item.menu (or (. cmp-src-menu-items entry.source.name) ""))
              item)}
   ; :formatters 
   ; {:insert_text copilot-format.remove_existing}

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
                                 {:name :path :max_item_count 12}])})
