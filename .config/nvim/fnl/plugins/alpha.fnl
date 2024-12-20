(local {: autoload} (require :nfnl.module))
(local {: concat} (autoload :nfnl.core))
(local {: kset} (autoload :config.util))

[{1 :goolord/alpha-nvim
  :dependencies [:Shatur/neovim-session-manager]
  :lazy false
  :config (fn []
            (let [sessions (require :session_manager) 
                  sconf (require :session_manager.config)
                  startify (require :alpha.themes.startify)
                  alpha (require :alpha)]
              (sessions.setup
                {:autoload_mode sconf.AutoloadMode.Disabled})
              
              (kset :n :<Leader><Space> ":Alpha<Cr>")

              (set startify.section.mru.val [{:type :padding :value 0}])

              (set startify.section.top_buttons.val
                   (concat 
                     startify.section.top_buttons.val
                     [(startify.button
                        :l
                        "Last Session" ":SessionManager load_last_session<Cr>")
                      (startify.button
                        :f
                        "Files for Session" ":SessionManager load_session<Cr>")]))

              (set startify.section.bottom_buttons.val
                   [(startify.button :t "Tasks" ":e ~/wiki/todo.md<Cr>")
                    (startify.button :p "Plugins" ":e ~/dotfiles/.config/nvim/fnl/plugins/basic.fnl<Cr>")
                    (startify.button :i "Init.fnl" ":e ~/dotfiles/.config/nvim/fnl/config/init.fnl<Cr>")
                    (startify.button :v "Vimrc" ":e ~/dotfiles/.vimrc<Cr>")
                    (startify.button :z "Zshrc" ":e ~/dotfiles/.zshrc<Cr>")
                    (startify.button :s "Scrutch" ":e ~/wiki/scratch.md<Cr>")
                    (startify.button :c "Career" ":e ~/wiki/programming/career.md<Cr>")
                    (startify.button :w "Windows" ":e /Volumes/exchange/<Cr>")
                    (startify.button :n "Nvim packages" ":e ~/.local/share/nvim/site/pack/packer/<Cr>")])


              ;; generated by: https://manytools.org/hacker-tools/ascii-banner/
              ; (set startify.section.header.val [
              ;                                   "                                                     "
              ;                                   "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ "
              ;                                   "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ "
              ;                                   "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ "
              ;                                   "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ "
              ;                                   "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ "
              ;                                   "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ "
              ;                                   "                                                     " ])

              (set startify.section.header.val [
                                                   "                   __                  "
                                                   "     ___   __  __ /\\_\\    ___ ___      "
                                                   "   /' _ `\\/\\ \\/\\ \\\\/\\ \\ /' __` __`\\    "
                                                   "   /\\ \\/\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\   "
                                                   "   \\ \\_\\ \\_\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\  "
                                                   "    \\/_/\\/_/\\/__/    \\/_/\\/_/\\/_/\\/_/  "])

              (alpha.setup startify.config)))}]
