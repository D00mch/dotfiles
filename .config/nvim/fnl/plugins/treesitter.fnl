(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))

(local parsers
  [:java :yaml :bash :kotlin :clojure :fennel :scheme :racket :lua :luadoc :vimdoc :vim 
   :markdown :markdown_inline :http :json :sql :dart :go :typescript :tsx :css :rust :python])

[{1 :nvim-treesitter/nvim-treesitter
  :lazy false ;; does not support lazy loading
  :dependencies [{1 :nvim-treesitter/nvim-treesitter-textobjects
                  :branch :main}]
  :branch :main
  :build ":TSUpdate"
  :opts {: parsers}
  :config (fn [_ {: parsers}]
          (let [ts-objects (require :nvim-treesitter-textobjects)
                ts-select  (require :nvim-treesitter-textobjects.select)
                tskset     (fn [ks obj]
                             (kset [:x :o] ks
                                   #(ts-select.select_textobject obj :textobjects)))]

            ;; Objects setup
            (ts-objects.setup {:select {:lookahead true}})
            (tskset :am "@function.outer")
            (tskset :im "@function.inner")
            (tskset :ac "@class.outer")
            (tskset :ic "@class.inner")
            (tskset :ar "@parameter.outer")
            (tskset :ir "@parameter.inner")
            (tskset :ak "@block.outer")
            (tskset :ik "@block.inner")

            ;; Treesitter setup

            (let [treesitter (require :nvim-treesitter)]
              (treesitter.setup)
              (treesitter.install parsers))

            (vim.api.nvim_create_autocmd :FileType
              {:group (vim.api.nvim_create_augroup :TreesitterHighlight {:clear true})
               :callback #(when (vim.tbl_contains parsers (vim.treesitter.language.get_lang vim.bo.filetype))
                            (vim.treesitter.start))})
            ))}]
