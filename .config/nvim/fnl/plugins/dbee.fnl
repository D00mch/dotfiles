(local {: autoload} (require :nfnl.module))
(local
  {: kset : get-word-under-cursor : get-word-under-selection}
  (autoload :config.util))
(local {: toggle} (require :config.which))

[{1 :kndndrj/nvim-dbee
  :dependencies [:MunifTanjim/nui.nvim]
  :build (fn []
           (let [dbee (require :dbee)]
             (dbee.install)))
  :init (fn []
          (let [dbee (require :dbee)]
            (toggle "d" "Dbee" #(dbee.toggle))))
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
           {:key :g9 :mode :n :action :page_last}]}
         
         :editor
         {:mappings
          [{:key :<D-CR> :mode :v :action :run_selection}
           {:key :<D-CR> :mode :n :action :run_file}]}})))}]
