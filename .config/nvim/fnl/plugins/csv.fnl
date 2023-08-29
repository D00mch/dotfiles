(local {: autoload} (require :nfnl.module))
(local {: bkset : vis-op+} (autoload :config.util))
(local {: merge} (autoload :nfnl.core))

(fn setup-csv []
  (bkset :x := ":ArrangeColumn<Cr>")
  (bkset :n :<Leader>= ":%ArrangeColumn<Cr>"))

(vim.api.nvim_create_autocmd
    :BufEnter
    {:pattern :*.csv
     :group    (vim.api.nvim_create_augroup :CSVSetup {:clear true})
     :callback setup-csv})

[{1 :chrisbra/csv.vim
  :lazy true
  :ft [:csv :csv_semicolon :csv_whitespace :csv_pipe
       :tsv :rfc_csv :rfc_semicolon]}]
