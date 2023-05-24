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
               ;; problems when I set this to 'true'
               ;; - can't use `vaf`, `dif`, etc... inside strings
               ;; - erorrs from cmp-conjure
               :additional_vim_regex_highlighting false
               }
   ; :refactor {:highlight_definitions {:enable true}
   ;            :smart_rename {:enable true
   ;                           :keymaps {:smart_rename :<Leader>rr}}}
   :indent    {:enable true}})

;; structural search and replace
(ssr.setup
  {:keymaps {:close :<D-w>
             :next_match :n
             :prev_match :N
             :replace_confirm :<CR>
             :replace_all :<Leader><Cr>}})

(kset [:n :x] :<Leader>sr ssr.open "Search/Replace")
