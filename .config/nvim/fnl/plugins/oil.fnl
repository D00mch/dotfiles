(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))

[{1 :stevearc/oil.nvim
  :config (fn []
            (let [oil (require :oil)
                  actions (require :oil.actions)]
              (kset :n :<Space>ff oil.open)
              (oil.setup
               {:keymaps
                {:th actions.toggle_hidden
                 :<Tab> actions.preview
                 :<Cr> actions.select_vsplit
                 :<S-Cr> actions.select}})))}]
