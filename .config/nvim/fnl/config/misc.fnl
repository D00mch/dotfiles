(local root-names [:.git :Makefile])

(local root-cache {})

(fn set-root []
  (var path (vim.api.nvim_buf_get_name 0))
  (when (= path "") (lua "return "))
  (set path (vim.fs.dirname path))
  (var root (. root-cache path))
  (when (= root nil)
    (local root-file (. (vim.fs.find root-names {: path :upward true}) 1))
    (when (= root-file nil) (lua "return "))
    (set root (vim.fs.dirname root-file))
    (tset root-cache path root))
  (vim.fn.chdir root))

(local root-augroup (vim.api.nvim_create_augroup :MyAutoRoot {}))

(vim.api.nvim_create_autocmd :BufEnter {:callback set-root :group root-augroup})	
