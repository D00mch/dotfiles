(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset} (autoload :config.util))

(local langs 
  [:java :yaml :bash :kotlin :clojure :fennel :scheme :racket :lua :luadoc :vimdoc :vim 
   :markdown :markdown_inline :http :json :sql :dart :go :typescript :css :rust])

[{1 :nvim-treesitter/nvim-treesitter
  :lazy false ;; does not support lazy loading
  :dependencies [{1 :nvim-treesitter/nvim-treesitter-textobjects
                  :branch :main}]
  :branch :main
  :build ":TSUpdate"
  :ft langs
  :init (fn []
          (let [ts-objects (require :nvim-treesitter-textobjects)
                ts-select  (require :nvim-treesitter-textobjects.select)
                tskset     (fn [ks obj]
                             (kset
                               [:x :o] 
                               ks
                               (fn []
                                 ((. ts-select :select_textobject) obj
                                  :textobjects))))
                parsers     langs]

            ;; Objects setup
            (ts-objects.setup {:select {:lookahead true}})
            (tskset :am "@function.outer")
            (tskset :im "@inner")
            (tskset :ac "@class.inner")
            (tskset :ic "@class.inner")
            (tskset :ar "@parameter.inner")
            (tskset :ir "@parameter.inner")
            (tskset :ak "@block.inner")
            (tskset :ik "@block.inner")

            ;; Treesitter setup

            (set nvim.o.foldmethod :expr)
            (set nvim.o.foldexpr "nvim_treesitter#foldexpr()")
            (let [treesitter (require :nvim-treesitter)]
              (treesitter.install parsers)
              (treesitter.setup))

           (vim.api.nvim_create_autocmd :FileType
                                        {:callback (fn [] (vim.treesitter.start))
                                         :pattern langs})
            ))
  :config true}]
