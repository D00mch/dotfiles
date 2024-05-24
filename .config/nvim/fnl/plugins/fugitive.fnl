(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))


(fn annotate-toggle []
  (let [current-dir (vim.fn.expand "%")
        in-annotate? (string.match current-dir "fugitiveblame$")]
    (vim.api.nvim_command (if in-annotate? "q" "G blame"))))

(fn fugitive-toggle []
  (let [current-dir (vim.fn.expand "%") ;; :echo expand('%:p')
        in-git? (string.match current-dir "^fugitive://")
        diff-view? (string.match current-dir "^diffview://")]
    (vim.api.nvim_command (if
                            diff-view? "tabc"
                            in-git? "bd"
                            in-git? "q"
                            "G"))))

[{1 :tpope/vim-fugitive
  :lazy false
  :cond true
  :init (fn []
          (kset [:n :x] :<space>ga annotate-toggle)
          (vim.api.nvim_command "set splitbelow")
          (kset [:n :x] :<Space>9 fugitive-toggle) ;; alt+9, (mapped to cmd+9 with karabiner) 
          )}]
