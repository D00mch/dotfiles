(module plugin.oil
  {require {tree nvim-tree
            oil oil
            actions oil.actions
            {: kset} util}})

(oil.setup
  {:keymaps
   {:th actions.toggle_hidden
    :<Tab> actions.preview
    :<Leader>v actions.select_vsplit}})

(kset :n :<Space>ff oil.open)
