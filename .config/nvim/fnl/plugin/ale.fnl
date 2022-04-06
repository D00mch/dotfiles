(module dotfiles.module.plugin.ale
  {require {nvim aniseed.nvim}})

(set nvim.g.ale_linters
  {:clojure [:clj-kondo]})

; "run on save
(set nvim.g.ale_lint_on_text_changed  "never")
(set nvim.g.ale_lint_on_insert_leave 0)

(set nvim.g.ale_cursor_detail 1)
(set nvim.g.ale_close_preview_on_insert 1)
(set nvim.g.ale_detail_to_floating_preview 1)
(set nvim.g.ale_floating_preview 1)

(nvim.ex.autocmd
  :FileType
  "clojure"
  "nmap <silent> [s <Plug>(ale_previous_wrap)")

(nvim.ex.autocmd
  :FileType
  "clojure"
  "nmap <silent> ]s <Plug>(ale_next_wrap)")

