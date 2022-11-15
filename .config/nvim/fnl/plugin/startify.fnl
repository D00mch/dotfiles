(module plugin.startify
  {require {nvim aniseed.nvim
            {: kset : bkset} util}
   require-macros [macros]})

(set nvim.g.startify_files_number 28)
(set nvim.g.startify_change_to_vcs_root 1)
(set nvim.g.webdevicons_enable_startify 1)

(kset :n "<Leader>m" ":Startify<cr>")

(set nvim.g.startify_lists
     [{:type "sessions"  :header ["    Sessions"]}
      {:type "files"     :header ["    Files"]}
      {:type "bookmarks" :header ["    Bookmarks"]}
      {:type "commands"  :header ["    Commands"]}])

(set nvim.g.startify_bookmarks
     [{:p "~/dotfiles/.config/nvim/fnl/plugin.fnl"}
      {:i "~/dotfiles/.config/nvim/fnl/init.fnl"}
      {:v "~/dotfiles/.vimrc"}
      {:d "~/dotfiles/.ideavimrc"}
      {:z "~/dotfiles/.zshrc"}
      {:s "~/wiki/scratch.md"}
      {:t "~/wiki/todo.md"}])

; (autocmd :User :Startified "execute 'nunmap <buffer> q'" )

(def group (vim.api.nvim_create_augroup :StartifyGroup {:clear true}))
(vim.api.nvim_create_autocmd
  :User
  {:pattern :Startified
   :group   group
   :callback (fn []
               (bkset :n :<Space>d ":silent! bd!<Cr>")
               (vim.keymap.del :n :q {:buffer 0}))})

; nvim larry 3d
 (set nvim.g.startify_custom_header [
 "                   __                  "
 "     ___   __  __ /\\_\\    ___ ___      "
 "   /' _ `\\/\\ \\/\\ \\\\/\\ \\ /' __` __`\\    "
 "   /\\ \\/\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\   "
 "   \\ \\_\\ \\_\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\  "
 "    \\/_/\\/_/\\/__/    \\/_/\\/_/\\/_/\\/_/  "
      ])

;(set nvim.g.startify_custom_header [
;"    <-. (`-')_      (`-')  _     <-. (`-')   " 
;"       \\( OO) )    _(OO ) (_)       \\(OO )_  "
;"    ,--./ ,--/,--.(_/,-.\\ ,-(`-'),--./  ,-.) "
;"    |   \\ |  |\\   \\ / (_/ | ( OO)|   `.'   | "
;"    |  . '|  |)\\   /   /  |  |  )|  |'.'|  | "
;"    |  |\\    |_ \\     /_)(|  |_/ |  |   |  | "
;"    |  | \\   |\\-'\\   /    |  |'->|  |   |  | "
;"    `--'  `--'    `-'     `--'   `--'   `--' "
;])

;; elite
; (set nvim.g.startify_custom_header [
; "    ▐ ▄  ▌ ▐·▪  • ▌ ▄ ·. " 
; "   •█▌▐█▪█·█▌██ ·██ ▐███▪"
; "   ▐█▐▐▌▐█▐█•▐█·▐█ ▌▐▌▐█·"
; "   ██▐█▌ ███ ▐█▌██ ██▌▐█▌"
; "   ▀▀ █▪. ▀  ▀▀▀▀▀  █▪▀▀▀"
;      ])
                                                

;; alpha looks like this
; (set nvim.g.startify_custom_header [
; "        ___           ___           ___           ___                       ___      "
; "       /\\__\\         /\\  \\         /\\  \\         /\\__\\          ___        /\\__\\     "
; "      /::|  |       /::\\  \\       /::\\  \\       /:/  /         /\\  \\      /::|  |    "
; "     /:|:|  |      /:/\\:\\  \\     /:/\\:\\  \\     /:/  /          \\:\\  \\    /:|:|  |    "
; "    /:/|:|  |__   /::\\~\\:\\  \\   /:/  \\:\\  \\   /:/__/  ___      /::\\__\\  /:/|:|__|__  "
; "   /:/ |:| /\\__\\ /:/\\:\\ \\:\\__\\ /:/__/ \\:\\__\\  |:|  | /\\__\\  __/:/\\/__/ /:/ |::::\\__\\ "
; "   \\/__|:|/:/  / \\:\\~\\:\\ \\/__/ \\:\\  \\ /:/  /  |:|  |/:/  / /\\/:/  /    \\/__/~~/:/  / "
; "       |:/:/  /   \\:\\ \\:\\__\\    \\:\\  /:/  /   |:|__/:/  /  \\::/__/           /:/  /  "
; "       |::/  /     \\:\\ \\/__/     \\:\\/:/  /     \\::::/__/    \\:\\__\\          /:/  /   "
; "       /:/  /       \\:\\__\\        \\::/  /       ~~~~         \\/__/         /:/  /    "
; "       \\/__/         \\/__/         \\/__/                                   \\/__/     "
; ])

;; generated by: https://manytools.org/hacker-tools/ascii-banner/
