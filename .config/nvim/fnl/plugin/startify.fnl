(module plugin.startify
  {require {nvim aniseed.nvim
            c aniseed.core
            ut   util}})

(def- map c.map)
(def- str c.str)

(set nvim.g.startify_files_number 18)
(set nvim.g.startify_change_to_vcs_root 1)
(set nvim.g.webdevicons_enable_startify 1)

(ut.nnoremap "<Leader>mp" ":Startify<cr>")

(set nvim.g.startify_lists 
     [{:type "sessions"  :header ["    Sessions"]}
      {:type "files"     :header ["    Files"]}
      {:type "commands"  :header ["    Commands"]}
      {:type "bookmarks" :header ["    Bookmarks"]}])

(set nvim.g.startify_bookmarks
     [{:e "~/dotfiles/.zshenv"}
      {:v "~/dotfiles/.vimrc"}
      {:i "~/dotfiles/.ideavimrc"}
      {:z "~/dotfiles/.zshrc"}
      {:w "~/wiki/todo.md"} ])

; (defn git-modified []
;   (let [files (nvim.ex.systemlist "git ls-files -m 2>/dev/null")]
;     (map 
;       (fn [f] (str "{'line':" f ", 'path':" f ":}"))
;       files)))
; (nvim.nvim_call_function "systemlist" "git ls-files -m 2>/dev/null")


