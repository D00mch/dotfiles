(module plugin.treesitter
  {autoload {treesitter nvim-treesitter.configs
             ssr ssr
             bqf bqf
             nvim aniseed.nvim
             {: kset} util}})

(set nvim.o.foldmethod :expr)
(set nvim.o.foldexpr "nvim_treesitter#foldexpr()")

(treesitter.setup
  {:ensure_installed [:java :lua :yaml :bash :kotlin
                      :clojure :fennel :scheme :racket
                      :markdown :markdown_inline
                      :http :json :sql]
   :highlight {:enable true
               ;:additional_vim_regex_highlighting true
               }
   :refactor {:highlight_definitions {:enable true}
              :smart_rename {:enable true
                             :keymaps {:smart_rename :<Leader>rr}}}
   :indent    {:enable true}})

;; structural search and replace
(ssr.setup
  {:keymaps {:close :<D-w>}})

(kset [:n :x] :<Leader>sr ssr.open "Search/Replace")

;; quickfix
(bqf.setup
  {:func_map {}})

(kset :n :<Space>pq :<Cmd>copen<Cr> "Quickfix")
