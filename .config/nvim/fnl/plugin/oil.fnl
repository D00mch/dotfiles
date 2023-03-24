(module plugin.oil
  {require {tree nvim-tree
            oil oil
            actions oil.actions
            {: kset} util}})

(oil.setup
  {:keymaps
   {:th actions.toggle_hidden
    :<Tab> actions.preview
    :<Cr> actions.select_vsplit
    :<S-Cr> actions.select}})

(kset :n :<Space>ff oil.open)
