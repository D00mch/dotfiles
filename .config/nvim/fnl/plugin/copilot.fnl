(module plugin.copilot
  {require {nvim aniseed.nvim
            copilot copilot
            c-cmp copilot_cmp
            panel copilot.panel
            suggestion copilot.suggestion
            {: toggle} plugin.which
            {: kset} util}})

(set nvim.g.copilot_started? false)

(defn init []
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
     :panel {:enabled true}
     :cmp {:enabled false
           :method :getCompletionsCycling}
     :copilot_node_command :node})
  ; (c-cmp.setup
      ;   {:method :getCompletionsCycling})
  (vim.cmd "Copilot suggestion")
  (suggestion.toggle_auto_trigger)
  (set nvim.g.copilot_started? true))

(defn copilot-toggle []
  (if nvim.g.copilot_started?
    (vim.cmd "Copilot toggle")
    (init)))

(toggle :c "Copilot" copilot-toggle)

; (kset [:n :i] :<M-n> suggestion.next {:desc "Open Copilot panel"})
; (kset [:n :i] :<M-p> suggestion.prev {:desc "Open Copilot panel"})
(kset [:n :i] :<M-p> panel.open {:desc "Open Copilot panel"})
