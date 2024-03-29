(local {: kset} (require :config.util))
(kset :n :<Space>ff #((. (require :oil) :open)))

[{1 :stevearc/oil.nvim
  :lazy true
  :config (fn []
            (let [oil (require :oil)
                  actions (require :oil.actions)]
              (oil.setup
               {:keymaps
                {:th actions.toggle_hidden
                 :<Tab> actions.preview
                 :<Cr> actions.select_vsplit
                 :<S-Cr> actions.select}})))}]
