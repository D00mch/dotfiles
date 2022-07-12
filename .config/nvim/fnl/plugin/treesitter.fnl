(module plugin.treesitter
  {autoload {treesitter nvim-treesitter.configs
             nvim aniseed.nvim}})

(set nvim.o.foldmethod :expr)
(set nvim.o.foldexpr "nvim_treesitter#foldexpr()")

(treesitter.setup
  {:ensure_installed [:clojure :fennel :java :lua :yaml :json :bash :kotlin
                      :markdown :markdown_inline]
   :highlight {:enable true
               ;:additional_vim_regex_highlighting false
               }
   :indent    {:enable true}
   :rainbow   {:enable true
               :extended_mode true
               :max_file_lines nil}})
