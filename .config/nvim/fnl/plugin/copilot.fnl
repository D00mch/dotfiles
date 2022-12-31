(module plugin.copilot
  {require {nvim aniseed.nvim
            copilot copilot
            c-cmp copilot_cmp
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
                           :next :<C-n>
                           :prev :<C-p>
                           :dismiss :<c-x>}}
     :cmp {:enabled true
           :method :getCompletionsCycling}
     :copilot_node_command :node})
  (c-cmp.setup
    {:method :getCompletionsCycling})
  ; (vim.cmd "Copilot suggestion")
  ;(suggestion.toggle_auto_trigger)
  )

(toggle :p "coPilot" copilot-setup)

; (kset [:n :i] :<M-n> suggestion.next {:desc "Open Copilot panel"})
; (kset [:n :i] :<M-p> suggestion.prev {:desc "Open Copilot panel"})
(kset [:n :i] :<M-p> panel.open {:desc "Open Copilot panel"})
