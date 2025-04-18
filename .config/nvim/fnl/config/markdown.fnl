(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: first : last : map} (autoload :nfnl.core))
(local {: join} (autoload :nfnl.string))
(local {: kset : bkset} (autoload :config.util))

;; headers

(fn insert-header []
  (let [s (vim.api.nvim_get_current_line)
        with-head? (string.find s "^#.*")
        final-line (.. (if with-head? "#" "# ") s)]
    (vim.api.nvim_set_current_line final-line)))

(fn remove-header []
  (let [s (vim.api.nvim_get_current_line)
        with-head? (string.find s "^#.*")
        with-heads? (string.find s "^##.*")
        final-line (string.sub s (if with-heads? 2 with-head? 3 0))]
    (vim.api.nvim_set_current_line final-line)))

;; tasks

(fn toggle-task-line [s]
  (let [selection (string.match s "^- %[(.)%]")]
    (if
      (= " " selection)   (s:gsub "^- %[.%]" "- %[X%]")
      (= "X" selection)   (s:gsub "^- %[.%]" "- %[ %]")
      (= (s:sub 1 1) "-") (s:gsub "^- " "- %[ %] ")
      (.. "- [ ] " s))))

(fn toggle-task []
  (let [s (toggle-task-line (vim.api.nvim_get_current_line))]
    (vim.api.nvim_set_current_line s)))

(fn toggle-task-selection []
  (let [start     (- (first (vim.api.nvim_buf_get_mark 0 "<")) 1)
        end       (first (vim.api.nvim_buf_get_mark 0 ">"))
        new-lines (map
                    toggle-task-line
                    (vim.api.nvim_buf_get_lines 0 start end 0))]
    (vim.api.nvim_buf_set_lines 0 start end 1 new-lines)))

(vim.api.nvim_create_user_command
  :MarkdownTaskToggleSelection toggle-task-selection
  {:nargs :* :desc "Toggle taks in markdown selection"})


;; setups

(fn setup-quote []
  (vim.cmd "call textobj#quote#init({'educate':0})")
  (bkset :n :<Space>tq ":ToggleEducate<Cr>" "auto quotes"))


(fn setup-pensil []
  (bkset :x := "gq")
  ;  (vim.api.nvim_set_option_value :formatoptions :t {:scope :local})
  ;  (vim.api.nvim_set_option_value :textwidth 80 {:scope :local})
  )

(fn setup-md []

  ;; setup lines
  (vim.cmd "set wrap linebreak nolist") ;; wrap without bracking a word
  (bkset :x := :gq)

  ; (setup-pensil)
  ; (setup-quote)

  ;; rest-client feature
  (kset :n :<Leader>ef :vic:ToggleTermSendVisualSelection<cr> {:noremap false})

  ;; insert headers
  (bkset :n := insert-header {:buffer true})
  (bkset :n :+ remove-header {:buffer true})

  ;; insert list tasks
  (bkset :n :- toggle-task)
  (bkset :x :- "<Esc>:MarkdownTaskToggleSelection<cr>")

  ;; j/k, left/right for long lines
  (bkset :n :j "v:count ? 'j' : 'gj'" {:expr true})
  (bkset :n :k "v:count ? 'k' : 'gk'" {:expr true})
  (bkset :n :<space>h "g0" {:remap false})
  (bkset :n :<space>l "g$" {:remap false})

  ;; insert markdown links
  (bkset :n :<D-k> "viw\"9di[<C-r>9](<C-r>*)<Esc>")
  (bkset :x :<D-k> "<Esc>`>a](<C-r>*)<C-o>`<[<Esc>")
  (bkset :n :<space>N "vaw\"9di[<C-r>9]: <C-r>*<Esc>F[yi[")
  (bkset :x :<space>N "<Esc>`>a]: <C-r>*<C-o>`<[<Esc>yi[")
  (bkset :n :<space>L "caw[]<Esc>hpla[]<Esc>i")
  (bkset :x :<space>L "<Esc>`>a][<C-r>*]<C-o>`<[<Esc>"))

(vim.api.nvim_create_autocmd
  :BufWinEnter
  {:pattern :*.md
   :group    (vim.api.nvim_create_augroup :MarkdownSetup {:clear true})
   :callback setup-md})

{}
