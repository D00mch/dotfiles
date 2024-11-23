(local {: autoload} (require :nfnl.module))
(local {: kset}
  (autoload :config.util))

(local pc-with-rights? (os.getenv :OPENAI_API_KEY))

[{1 :kndndrj/nvim-dbee
  :cond pc-with-rights?
  :dependencies [:MunifTanjim/nui.nvim]
  :build (fn []
           (let [dbee (require :dbee)]
             (dbee.install)))
  :init (fn []
          (let [dbee (require :dbee)]
            (kset :n :<Space>td #(dbee.toggle) "Dbee")))
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
