(module init
  {require {core aniseed.core
            nvim aniseed.nvim
            util util}})

;; Load all modules in no particular order.
(->> (util.glob (.. util.config-path "/lua/plugin/*.lua"))
     (core.run! (fn [path]
                  (require (string.gsub path ".*/(.-)/(.-)%.lua" "%1.%2")))))
