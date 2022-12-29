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
                  :keymap {:accept :<M-a>
                           :accept_word false
                           :accept_line false
                           :next :<M-n>
                           :prev :<M-p>
                           :dismiss :<c-x>}}
     :copilot_node_command :node})
  (suggestion.toggle_auto_trigger))

(toggle :p "coPilot" copilot-setup)

(kset [:n :i] :<M-p> panel.open {:desc "Open Copilot panel"})
