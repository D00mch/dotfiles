(local {: autoload} (require :nfnl.module))
(local {: bkset} (autoload :config.util))

(fn setup-csv []
  (bkset :n := ":RainbowAlign<Cr>"))

(vim.api.nvim_create_autocmd
    :BufEnter
    {:pattern :*.csv
     :group    (vim.api.nvim_create_augroup :CSVSetup {:clear true})
     :callback setup-csv})

[{1 :cameron-wags/rainbow_csv.nvim
  :lazy true
  :config true
  :ft [:csv :csv_semicolon :csv_whitespace :csv_pipe
       :tsv :rfc_csv :rfc_semicolon]
  :cmd [:RainbowDelim :RainbowDelimSimple :RainbowDelimQuoted :RainbowMultiDelim]}]
