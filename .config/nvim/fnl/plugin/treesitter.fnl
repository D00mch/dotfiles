(module plugin.treesitter
  {autoload {treesitter nvim-treesitter.configs
             ssr ssr
             nvim aniseed.nvim
             ts-rainbow ts-rainbow
             {: kset} util}})

(set nvim.o.foldmethod :expr)
(set nvim.o.foldexpr "nvim_treesitter#foldexpr()")

(treesitter.setup
  {:ensure_installed [:java :lua :yaml :bash :kotlin
                      :clojure :fennel :scheme :racket
                      :markdown :markdown_inline
                      :http :json :sql :dart :vim]
   :rainbow {:enable true
             :strategy ts-rainbow.strategy.global}
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
