(local {: autoload} (require :nfnl.module))
(local {: bkset} (autoload :config.util))

(fn setup-rest []
  (bkset :n :<Leader>a "<Cmd>Rest open<CR>" "Open HTTP results")
  (bkset :n :<Leader>e "<Cmd>Rest run<CR>" "Run HTTP request")
  (bkset :n :<Leader>q "<Cmd>Rest run<CR>" "Run HTTP request"))

[{1 :rest-nvim/rest.nvim
  :main :rest-nvim
  :lazy true
  :ft [:http]
  :init (fn []
          (vim.api.nvim_create_autocmd
            :BufWinEnter
            {:pattern :*.http
             :group    (vim.api.nvim_create_augroup :HttpMappings {:clear true})
             :callback setup-rest}))
  :opts {}}]
