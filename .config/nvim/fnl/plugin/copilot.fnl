(module plugin.copilot
  {require {nvim aniseed.nvim
            copilot copilot
            panel copilot.panel
            suggestion copilot.suggestion
            {: toggle} plugin.which
            {: kset} util}})

(defn copilot-setup []
  (copilot.setup
    {:suggestion {:enabled true
                  :auto_trigger true
                  :debounce 75
                  :keymap {:accept :å ;; alt+a
                           :accept_word false
                           :accept_line false
                           :next :<c-n>
                           :prev :<c-p>
                           :dismiss :<c-x>}}
     :copilot_node_command :node})
  (suggestion.toggle_auto_trigger))

(toggle :p "coPilot" copilot-setup)

;; alt + p
(kset [:n :i] :π panel.open {:desc "Open Copilot panel"})
