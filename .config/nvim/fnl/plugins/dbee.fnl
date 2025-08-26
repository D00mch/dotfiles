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
           {:key :g9 :mode :n :action :page_last}]}
         
         :editor
         {:mappings
          [{:key :<D-CR> :mode :v :action :run_selection}
           {:key :<D-CR> :mode :n :action :run_file}]}})))}]
