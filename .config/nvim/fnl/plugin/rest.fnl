(module plugin.rest
  {autoload {nvim aniseed.nvim
            rest rest-nvim
            {: kset} util}})

(kset :v :gjq :!jq<cr>)

(rest.setup
  {:result_split_in_place true
   :jump_to_request true})

(defn setup-rest []
  (kset :n :<Leader>a :<Plug>RestNvimPreview)
  (kset :n :<Leader>e :<Plug>RestNvim)
  (kset :n :<Leader>q :<Plug>RestNvim))

(vim.api.nvim_create_autocmd
  :BufWinEnter
  {:pattern :*.http
   :callback setup-rest})
