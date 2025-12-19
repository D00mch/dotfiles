(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset} (autoload :config.util))

[{1 :nvim-treesitter/nvim-treesitter
  :lazy false ;; does not support lazy loading
  :dependencies []
  :build ":TSUpdate"
  :init (fn []
          (set nvim.o.foldmethod :expr)
          (set nvim.o.foldexpr "nvim_treesitter#foldexpr()")
          (let [treesitter (require :nvim-treesitter)]
            (treesitter.install 
              [:java :yaml :bash :kotlin
               :clojure :fennel :scheme :racket
               :lua :luadoc :vimdoc :vim
               :markdown :markdown_inline
               :http :json :sql :dart :go
               :typescript :css :rust])))
  :config true}]
