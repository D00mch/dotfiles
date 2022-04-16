(module plugin.treesitter
  {autoload {treesitter nvim-treesitter.configs
             nvim aniseed.nvim}})

(set nvim.o.foldmethod :expr)
(set nvim.o.foldexpr "nvim_treesitter#foldexpr()")

(treesitter.setup
  {:ensure_installed [:clojure :fennel :java :dart :markdown :lua :yaml]
   :highlight {:enable true}
   :refactor  {:highlight_definitions     {:enable               true
                                           :clear_on_cursor_move true}
               :smart_rename              {:enable   true
                                           :kemaps  {:smart_rename "grr"}}
               :navigation                {:enable   true
                                           :keymaps {:goto_next_usage "∫"}}
               :clear_on_cursor_move true}
   :indent    {:enable true}
   :rainbow   {:enable true
               :extended_mode true
               :max_file_lines nil}})
