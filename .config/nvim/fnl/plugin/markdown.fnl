(module plugin.wiki
  {require {nvim aniseed.nvim
            {: toggle} plugin.which
            {: join} aniseed.string
            u util}
   require-macros [macros]})

(defn setup-quote []
  (vim.cmd "call textobj#quote#init({'educate':0})")
  (toggle "q" "auto quotes" ":ToggleEducate<Cr>" 0))

(defn setup-pensil []
; (u.bm :x := "gq")
  (vim.api.nvim_set_option_value :formatoptions :t {:scope :local})
  (vim.api.nvim_set_option_value :textwidth 80 {:scope :local}))

(defn setup-md []
  (vim.cmd "set wrap linebreak nolist") ;; wrap without bracking a word

  (setup-pensil)
  (setup-quote)

  ;; insert headers
  (u.bm :n := ":MarkdownHeaderInsert<cr>")
  (u.bm :n :+ ":MarkdownHeaderRemove<cr>")

  ;; insert list tasks
  (u.bm :n :- ":MarkdownTaskToggle<cr>")
  (u.bm :x :- ":MarkdownTaskToggle<cr>")

  ;; insert markdown links
  (u.bm :n :<space>K "caw[]<Esc>hpla()<Esc>i")
  (u.bm :x :<space>K "<Esc>`>a](<C-r>*)<C-o>`<[<Esc>")
  (u.bm :n :<space>L "caw[]<Esc>hpla[]<Esc>i")
  (u.bm :x :<space>L "<Esc>`>a][<C-r>*]<C-o>`<[<Esc>"))

(vim.api.nvim_create_autocmd
  :BufWinEnter
  {:pattern :*.md
   :callback setup-md})

;; custom commands

(defn toggle-taks []
  (let [s (vim.api.nvim_get_current_line)
        selection (string.match s "^- %[(.)%]")
        s (if 
            (= " " selection)   (s:gsub "^- %[.%]" "- %[X%]")
            (= "X" selection)   (s:gsub "^- %[.%]" "- %[ %]")
            (= (s:sub 1 1) "-") (s:gsub "^- " "- %[ %] ")
            (.. "- [ ] " s))]
    (vim.api.nvim_set_current_line s)))

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

(vim.api.nvim_create_user_command
  :MarkdownHeaderInsert insert-header
  {:nargs :* :desc "Insert markdown header"})

(vim.api.nvim_create_user_command
  :MarkdownHeaderRemove remove-header
  {:nargs :* :desc "Insert markdown header"})

(vim.api.nvim_create_user_command
  :MarkdownTaskToggle toggle-taks
  {:nargs :* :desc "Toggle taks in markdown"})

(u.m :n :<Leader>ef :vap2ko2j:ToggleTermSendVisualSelection<cr>)
