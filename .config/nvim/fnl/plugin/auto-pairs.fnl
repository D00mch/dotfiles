(module plugin.auto-pairs
  {autoload {core aniseed.core
             nvim aniseed.nvim}
   require-macros [macros]})

(defn init []
  (let [d nvim.g.AutoPairs] 
    (tset d "'" nil)
    (tset d "`" nil)
    (set nvim.b.AutoPairs d)))

(vim.schedule
  (fn [] 
    (autocmd :FileType
             "clojure,fennel,scheme"
             "lua require('plugin.auto-pairs').init()")))
