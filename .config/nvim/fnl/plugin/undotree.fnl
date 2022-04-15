(module plugin.undotree
  {autoload {nvim aniseed.nvim}})

(nvim.ex.set :undofile)

;; persistent undo settings
(set nvim.o.undodir (.. (nvim.fn.stdpath "data") "/undo"))            
(set nvim.o.undolevels 1000)
(set nvim.o.undoreload 10000)

(nvim.set_keymap
  :n
  :<leader>ut
  ":UndotreeShow<cr>:UndotreeFocus<cr>"
  {:noremap true
   :silent true})
