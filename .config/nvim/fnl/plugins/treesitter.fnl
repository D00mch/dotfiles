(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset} (autoload :config.util))

[{1 :nvim-treesitter/nvim-treesitter
  :lazy true
  :event :VeryLazy
  :dependencies [:HiPhish/nvim-ts-rainbow2
                 :nvim-treesitter/nvim-treesitter-textobjects
                 :nvim-treesitter/nvim-treesitter-refactor]
  :build ":TSUpdate"
  :init (fn []
          (set nvim.o.foldmethod :expr)
          (set nvim.o.foldexpr "nvim_treesitter#foldexpr()"))
  :config (fn []
            (let [treesitter (require :nvim-treesitter.configs)]
              (treesitter.setup
                {:ensure_installed [:java :yaml :bash :kotlin
                                    :clojure :fennel :scheme :racket
                                    :lua :luadoc :vimdoc :vim
                                    :markdown :markdown_inline
                                    :http :json :sql :dart :go
                                    :typescript :css :rust]
                 :highlight {:enable true
                             ;; problems when I set this to 'true'
                             ;; - can't use `vaf`, `dif`, etc... inside strings
                             ;; - erorrs from cmp-conjure
                             :additional_vim_regex_highlighting false
                             }
                 ; :refactor {:highlight_definitions {:enable true}
                 ;            :smart_rename {:enable true
                 ;                           :keymaps {:smart_rename :<Leader>rr}}}
                 :textobjects {:select
                               {:enable true
                                :keymaps 
                                {:am "@function.outer"
                                 :im "@function.inner"
                                 :ac "@class.outer"
                                 :ic "@class.inner"}}
                               :swap
                               {:enable true
                                :swap_next {:g> "@parameter.inner"}
                                :swap_previous {:g< "@parameter.inner"}}}
                 :indent    {:enable true}})))}]
