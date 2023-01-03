(module plugin.csv
  {require {nvim aniseed.nvim
            {: kset : bkset} util}})

(set nvim.g.no_csv_maps true)

(defn setup-csv []
  (bkset :x := ":ArrangeColumn<Cr>")
  (bkset :n :<Leader>= ":%ArrangeColumn<Cr>"))

(vim.api.nvim_create_autocmd
  :BufEnter
  {:pattern :*.csv
   :group    (vim.api.nvim_create_augroup :CSVSetup {:clear true})
   :callback setup-csv})
