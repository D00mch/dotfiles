(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset} (autoload :config.util))

[{1 :nvim-treesitter/nvim-treesitter
  :lazy true
  :event :bufread
  :dependencies [:HiPhish/nvim-ts-rainbow2
                 :nvim-treesitter/nvim-treesitter-refactor]
  :build ":TSUpdate"
  :init (fn []
          (set nvim.o.foldmethod :expr)
          (set nvim.o.foldexpr "nvim_treesitter#foldexpr()"))
  :config (fn []
            (let [treesitter (require :nvim-treesitter.configs)
                  ts-rainbow (require :ts-rainbow)]
              (treesitter.setup
                {:ensure_installed [:java :lua :yaml :bash :kotlin
                                    :clojure :fennel :scheme :racket
                                    :markdown :markdown_inline
                                    :http :json :sql :dart :vim :go]
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
                 :indent    {:enable true}})))}]
