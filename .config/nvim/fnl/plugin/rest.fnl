(module plugin.rest
  {autoload {nvim aniseed.nvim
            rest rest-nvim
            util util}})

(util.m :v :gjq :!jq<cr>)

(rest.setup
  {:result_split_in_place true
   :jump_to_request true})

(defn setup-rest []
  (util.bm :n :<Leader>a :<Plug>RestNvimPreview)
  (util.bm :n :<Leader>f :<Plug>RestNvim))

(vim.api.nvim_create_autocmd
  :BufWinEnter
  {:pattern :*.http
   :callback setup-rest})
