;; There is a simlink to this file form nvim/ftplugin
(vim.keymap.set
  :n
  :o
  (fn []
    (let [line (vim.api.nvim_get_current_line)
          should-add-comma (string.find line "[^,{[]$")]
      (if should-add-comma "A,<cr>" :o)))
  {:buffer true :expr true})	
