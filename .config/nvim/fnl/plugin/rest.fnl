(module plugin.rest
  {autoload {nvim aniseed.nvim
            rest rest-nvim
            {: bkset} util}})

(rest.setup
  {:result_split_in_place true
   :jump_to_request true})

(defn setup-rest []
  (bkset :n :<Leader>a :<Plug>RestNvimPreview)
  (bkset :n :<Leader>e :<Plug>RestNvim)
  (bkset :n :<Leader>q :<Plug>RestNvim))

(vim.api.nvim_create_autocmd
  :BufWinEnter
  {:pattern :*.http
   :group    (vim.api.nvim_create_augroup :HttpMappings {:clear true})
   :callback setup-rest})
