(module plugin.which
  {autoload {key which-key}})

(key.setup 
  {:plugins {:spelling {:enabled true
                        :suggestions 12}}})
