(module plugin.startify
  {require {nvim aniseed.nvim
            ut   util}})

(set nvim.g.startify_files_number 18)
(set nvim.g.startify_change_to_vcs_root 1)
(set nvim.g.webdevicons_enable_startify 1)

(ut.nmap "<Leader>mp" ":Startify<cr>")

(set nvim.g.startify_lists 
     [{:type "sessions"  :header ["    Sessions"]}
      {:type "bookmarks" :header ["    Bookmarks"]}
      {:type "files"     :header ["    Files"]}
      {:type "commands"  :header ["    Commands"]}])

(set nvim.g.startify_bookmarks
     [{:p "~/dotfiles/.config/nvim/fnl/plugin.fnl"}
      {:n "~/dotfiles/.config/nvim/fnl/init.fnl"}
      {:v "~/dotfiles/.vimrc"}
      {:i "~/dotfiles/.ideavimrc"}
      {:z "~/dotfiles/.zshrc"}
      {:t "~/wiki/todo.md"} ])
