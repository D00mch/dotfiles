(module plugin.rainbow
  {require {nvim aniseed.nvim}})

(vim.schedule
  (fn [] 
    (nvim.ex.autocmd
      :FileType
      "clojure,fennel,lisp,scheme"
      "RainbowParentheses")))
