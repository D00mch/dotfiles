(module plugin.auto-pairs
  {autoload {core aniseed.core
             nvim aniseed.nvim}})

(defn init []
  (set nvim.b.AutoPairs (vim.empty_dict)))

(vim.schedule
  (fn [] 
    (nvim.ex.autocmd
      :FileType
      "clojure,fennel,scheme"
      "lua require('plugin.auto-pairs').init()")))
