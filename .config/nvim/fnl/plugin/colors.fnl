(module plugin.colors
  {autoload {nvim aniseed.nvim
             {: kset} util
             {: first} aniseed.core}})

(vim.api.nvim_create_autocmd
  :BufWinEnter
  {:pattern :*.dart
   :group    (vim.api.nvim_create_augroup :DartColors {:clear true})
   :callback (fn []
               (set nvim.g.colorizer_hex_pattern [:0xFF "\\%(\\x\\{6}\\)" ""]))})

(kset :n :<Space>cc "<Plug>Colorizer")
(kset :x :<Space>cc ":'<,'>ColorHighlight<Cr>")
