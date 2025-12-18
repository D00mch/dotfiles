(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset} (autoload :config.util))

[{1 :nvim-treesitter/nvim-treesitter
  :lazy false
  :event :VeryLazy
  :dependencies [
                 ]
  :build ":TSUpdate"
  :init (fn []
          (set nvim.o.foldmethod :expr)
          (set nvim.o.foldexpr "nvim_treesitter#foldexpr()"))
  :config (fn []
            (let [treesitter (require :nvim-treesitter)]
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
                 :indent    {:enable true}})))}]
