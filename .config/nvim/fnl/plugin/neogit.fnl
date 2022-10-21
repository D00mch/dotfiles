(module plugin.neogit
  {require {nvim aniseed.nvim
            neogit neogit
            util util}})

(neogit.setup
  {:kind :tab
   :integrations {:diffview true}
   :disable_commit_confirmation true
   :mappings {:status {:o :Toggle
                       :q "" }}})

(defn neogit-toggle []
  (let [current-dir (vim.fn.expand "%") ;; :echo expand('%:p')
        in-git? (string.match current-dir "NeogitStatus$")]
    (vim.api.nvim_command (if in-git? "q" "Neogit"))))

(vim.keymap.set [:n :x :i] :ª neogit-toggle) ;; alt+9, (mapped to cmd+9 with karabiner) 
(util.m :i :ª "<Esc>ª" {:noremap false})     ;; alt+9


(defn annotate-toggle []
  (let [current-dir (vim.fn.expand "%")
        in-annotate? (string.match current-dir "DiffviewFileHistoryPanel$")]
    (vim.api.nvim_command (if in-annotate? "q" "DiffviewFileHistory %"))))

(vim.keymap.set [:n] :<space>ga annotate-toggle)
(util.m :x :<space>ga ":DiffviewFileHistory<cr>" {:noremap false})

;; code in case they don't approve my pr https://github.com/TimUntersberger/neogit/pull/375
; (def group (vim.api.nvim_create_augroup :MyCustomNeogitEvents {:clear true}))
; (vim.api.nvim_create_autocmd
;   :User
;   {:pattern :NeogitStatusRefreshed
;    :group   group
;    :callback (fn [] (util.bm "" :q "<Plug>(leap-forward)" {:noremap false}))})
