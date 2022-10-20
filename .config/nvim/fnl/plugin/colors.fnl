(module plugin.colors
  {autoload {nvim aniseed.nvim
             u util
             {: first} aniseed.core}})

(vim.api.nvim_create_autocmd
  :BufWinEnter
  {:pattern :*.dart
   :callback (fn []
               (set nvim.g.colorizer_hex_pattern [:0xFF "\\%(\\x\\{6}\\)" ""]))})

(u.m "" :<Space>cc "<Plug>Colorizer")
(u.m :x :<Space>cc ":'<,'>ColorHighlight<Cr>")
