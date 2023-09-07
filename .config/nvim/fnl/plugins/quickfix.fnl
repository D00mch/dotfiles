(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))

[{1 :kevinhwang91/nvim-bqf
  :lazy true
  :ft [:qf]
  :init (fn []
          (kset :n :<Space>pq :<Cmd>copen<Cr> "Quickfix")
          (kset :n "]q" ":cn<cr>" "Quickfix: next item")
          (kset :n "[q" ":cp<cr>" "Quickfix: prev item"))
  :opts {:func_map {}}
  :config true}]
