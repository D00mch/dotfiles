(local {: autoload} (require :nfnl.module))
(local {: kset}
  (autoload :config.util))

[{1 :kndndrj/nvim-dbee
  :lazy true
  :cmd :Dbee
  :cond true
  :dependencies [:MunifTanjim/nui.nvim]
  :build (fn []
           (let [dbee (require :dbee)]
             (dbee.install)))
  :init (fn []
          (kset :n :<Space>td ":Dbee toggle<CR>" "Dbee"))
  :config
  (fn []
    (let [dbee (require :dbee)]
      (dbee.setup
        {
         :result
         {:mappings
          [{:key :gn :mode :n :action :page_next}
           {:key :gp :mode :n :action :page_prev}
           {:key :g0 :mode :n :action :page_first}
           {:key :g9 :mode :n :action :page_last}

           ;; Yank rows as csv/json
           {:key "yaj" :mode "n" :action "yank_current_json"}
           {:key "yaj" :mode "v" :action "yank_selection_json"}
           {:key "yaJ" :mode "" :action "yank_all_json"}
           {:key "yac" :mode "n" :action "yank_current_csv"}
           {:key "yac" :mode "v" :action "yank_selection_csv"}
           {:key "yaC" :mode "" :action "yank_all_csv"}

           ;; Cancel current call execution
           {:key "<D-c>" :mode "" :action "cancel_call"}
           {:key "<C-c>" :mode "" :action "cancel_call"}
           ]}

         :drawer
         {:mappings 
          [;; Manually refresh drawer
           {:key "r" :mode "n" :action "refresh"}
           ;; action_1 opens a note or executes a helper
           {:key "<CR>" :mode "n" :action "action_1"}
           ;; action_2 renames a note or sets the connection as active manually
           {:key "r" :mode "n" :action "action_2"}
           ;; action_3 deletes a note or connection (removes connection from the file if you configured it like so)
           {:key "d" :mode "n" :action "action_3"}
           ;; These are self-explanatory:
           ;; {:key "c" :mode "n" :action "collapse"}
           ;; {:key "e" :mode "n" :action "expand"}
           {:key "o" :mode "n" :action "toggle"}
           ;; Mappings for menu popups:
           {:key "<CR>" :mode "n" :action "menu_confirm"}
           {:key "y" :mode "n" :action "menu_yank"}
           {:key "<Esc>" :mode "n" :action "menu_close"}
           {:key "q" :mode "n" :action "menu_close"}]}
         
         :editor
         {:mappings
          [{:key :<D-CR> :mode :v :action :run_selection}
           {:key :<D-CR> :mode :n :action :run_file}]}})))}]
