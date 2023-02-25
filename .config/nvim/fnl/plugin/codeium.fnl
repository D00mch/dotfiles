(module plugin.codeuim
  {autoload {nvim aniseed.nvim
             {: first} aniseed.core
             {: kset} util
             {: toggle} plugin.which
             }})

(set nvim.g.codeium_disable_bindings true)
(set nvim.g.codeium_manual true)
(set nvim.g.codeium_enabled false)

(kset :i :<M-a> (fn [] ((. vim.fn "codeium#Accept"))) {:expr true})
(kset :i :<M-x> (fn [] ((. vim.fn "codeium#Clear"))) {:expr true})
(kset :i :<C-n> (fn [] ((. vim.fn "codeium#CycleCompletions") 1)) {:expr true})
(kset :i :<C-p> (fn [] ((. vim.fn "codeium#CycleCompletions") (- 1))) {:expr true})
(kset :i :<M-tab> (fn [] ((. vim.fn "codeium#Complete"))) {:expr true})

(defn codeuim-toggle []
  (set nvim.g.codeium_enabled (not nvim.g.codeium_enabled)))

(toggle :c "Codeuim" codeuim-toggle)

; (vim.keymap.set :i :<C-g> (fn [] ((. vim.fn "codeium#Accept"))) {:expr true})
; (vim.keymap.set :i "<c-;>" (fn [] ((. vim.fn "codeium#CycleCompletions") 1)) {:expr true})
; (vim.keymap.set :i "<c-,>" (fn [] ((. vim.fn "codeium#CycleCompletions") (- 1)))
;                 {:expr true})
; (vim.keymap.set :i :<c-x> (fn [] ((. vim.fn "codeium#Clear"))) {:expr true})	
