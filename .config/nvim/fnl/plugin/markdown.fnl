(module plugin.wiki
  {require {nvim aniseed.nvim
            {: first : last : map} aniseed.core
            {: toggle} plugin.which
            {: join} aniseed.string
            u util}
   require-macros [macros]})

;; headers

(defn insert-header []
  (let [s (vim.api.nvim_get_current_line)
        with-head? (string.find s "^#.*")
        final-line (.. (if with-head? "#" "# ") s)]
    (vim.api.nvim_set_current_line final-line)))

(defn remove-header []
  (let [s (vim.api.nvim_get_current_line)
        with-head? (string.find s "^#.*")
        with-heads? (string.find s "^##.*")
        final-line (string.sub s (if with-heads? 2 with-head? 3 0))]
    (vim.api.nvim_set_current_line final-line)))

;; tasks

(defn- toggle-task-line [s]
  (let [selection (string.match s "^- %[(.)%]")]
    (if 
      (= " " selection)   (s:gsub "^- %[.%]" "- %[X%]")
      (= "X" selection)   (s:gsub "^- %[.%]" "- %[ %]")
      (= (s:sub 1 1) "-") (s:gsub "^- " "- %[ %] ")
      (.. "- [ ] " s))))

(defn toggle-task []
  (let [s (toggle-task-line (vim.api.nvim_get_current_line))]
    (vim.api.nvim_set_current_line s)))

(defn toggle-task-selection []
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

(defn setup-quote []
  (vim.cmd "call textobj#quote#init({'educate':0})")
  (toggle "q" "auto quotes" ":ToggleEducate<Cr>" 0))

(defn setup-pensil []
; (u.bm :x := "gq")
  (vim.api.nvim_set_option_value :formatoptions :t {:scope :local})
  (vim.api.nvim_set_option_value :textwidth 80 {:scope :local}))

(defn setup-md []
  (u.bm :n :<Cr> :o) ;; unmap follow-md-links <Cr>
  (u.bm :n :gd ":lua require('follow-md-links').follow_link()<cr>")

  (vim.cmd "set wrap linebreak nolist") ;; wrap without bracking a word

  (setup-pensil)
  (setup-quote)

  ;; rest-client feature
  (u.m :n :<Leader>ef :vic:ToggleTermSendVisualSelection<cr> {:noremap false})

  ;; insert headers
  (vim.keymap.set :n := insert-header {:buffer true})
  (vim.keymap.set :n :+ remove-header {:buffer true})

  ;; insert list tasks
  (vim.keymap.set :n :- toggle-task)
  (u.bm :x :- "<Esc>:MarkdownTaskToggleSelection<cr>")

  ;; insert markdown links
  (u.bm :n :<space>K "caw[]<Esc>hpla()<Esc>i")
  (u.bm :x :<space>K "<Esc>`>a](<C-r>*)<C-o>`<[<Esc>")
  (u.bm :n :<space>L "caw[]<Esc>hpla[]<Esc>i")
  (u.bm :x :<space>L "<Esc>`>a][<C-r>*]<C-o>`<[<Esc>"))

(vim.api.nvim_create_autocmd
  :BufWinEnter
  {:pattern :*.md
   :callback setup-md})
