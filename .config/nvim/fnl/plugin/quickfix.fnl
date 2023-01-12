(module plugin.quickfix
  {autoload {treesitter nvim-treesitter.configs
             bqf bqf
             {: kset} util}})

;; quickfix
(bqf.setup
  {:func_map {}})

(kset :n :<Space>pq :<Cmd>copen<Cr> "Quickfix")
(kset :n "]q" ":cn<cr>")
(kset :n "[q" ":cp<cr>")
