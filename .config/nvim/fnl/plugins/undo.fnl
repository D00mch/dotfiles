(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset} (autoload :config.util))

[{1 :mbbill/undotree
  :cmd :UndotreeShow
  :lazy true
  :init (fn []
          (nvim.ex.set :undofile)

          ;; persistent undo settings
          (set nvim.o.undodir (.. (nvim.fn.stdpath "data") "/undo"))
          (set nvim.o.undolevels 1000)
          (set nvim.o.undoreload 10000)

          (kset :n :<Space>ut ":UndotreeShow<cr>:UndotreeFocus<cr>" {:silent true})

          (vim.cmd "function g:Undotree_CustomMap()
                   nmap <buffer> <D-w> q
                   map <buffer> d D
                   endfunction"))}]
