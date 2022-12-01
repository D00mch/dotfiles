(module plugin.treesitter
  {autoload {treesitter nvim-treesitter.configs
             nvim aniseed.nvim}})

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
                             :keymaps {:smart_rename :<Space>rr}}}
   :indent    {:enable true}
   :rainbow   {:enable true
               :extended_mode true
               :max_file_lines nil}})
