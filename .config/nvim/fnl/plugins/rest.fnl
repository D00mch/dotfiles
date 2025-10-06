(local {: autoload} (require :nfnl.module))
(local {: bkset} (autoload :config.util))

(fn setup-rest []
  (bkset :n :<Leader>a :<Plug>RestNvimPreview)
  (bkset :n :<Leader>e :<Plug>RestNvim)
  (bkset :n :<Leader>q :<Plug>RestNvim))

[{1 :rest-nvim/rest.nvim
  :lazy true
  :ft [:http]
  :init (fn []
          (vim.api.nvim_create_autocmd
            :BufWinEnter
            {:pattern :*.http
             :group    (vim.api.nvim_create_augroup :HttpMappings {:clear true})
             :callback setup-rest}))
  :opts {:result_split_in_place true
         :jump_to_request true}
  :config true}]
