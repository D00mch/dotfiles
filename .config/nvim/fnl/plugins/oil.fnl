(local {: kset} (require :config.util))
(kset :n :<Space>f #((. (require :oil) :open)))

[{1 :stevearc/oil.nvim
  :lazy true
  :config (fn []
            (let [oil (require :oil)
                  actions (require :oil.actions)]
              (vim.api.nvim_command "set splitright")
              (oil.setup
               {:keymaps
                {:th actions.toggle_hidden
                 :<Tab> actions.preview
                 :<Cr> actions.select
                 :<S-Cr> actions.select_vsplit
                 }})))}]
