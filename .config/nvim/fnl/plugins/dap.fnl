(local {: autoload} (require :nfnl.module))
(local {: bkset} (autoload :config.util))
(local wk (autoload :which-key))

[{1 :mfussenegger/nvim-dap
  :dependencies [:nvim-neotest/nvim-nio ;; required by nvim-dap-ui
                 :rcarriga/nvim-dap-ui
                 :jay-babu/mason-nvim-dap.nvim
                 :leoluz/nvim-dap-go
                 :theHamsta/nvim-dap-virtual-text]
  :lazy true
  :ft [:go :gomod]
  :config (fn []
            (let [mason (require :mason-nvim-dap)
                  dap-go (require :dap-go :go)
                  dap-virtual (require "nvim-dap-virtual-text")]
              (mason.setup {:ensure_installed [:delve ;; go
                                                     ]})
              (dap-go.setup)
              (dap-virtual.setup))

            (wk.add {1 :<leader>d  :group :Debug :desc "+debug"})
            (let [dap (require :dap)]
              (bkset :n :<leader>db dap.toggle_breakpoint "Toggle Breakpoint")
              (bkset :n :<leader>dc dap.continue          "Continue")
              (bkset :n :<leader>da dap.continue          "Run with Args")
              (bkset :n :<leader>dC dap.run_to_cursor     "Run to Cursor")
              (bkset :n :<leader>dg dap.goto_             "Go to Line (No Execute)")
              (bkset :n :<leader>dk dap.up                "Up")
              (bkset :n :<leader>dl dap.run_last          "Run Last")
              (bkset :n :<leader>dj dap.step_over         "Step Over")
              (bkset :n :<leader>do dap.step_out          "Step Out")
              (bkset :n :<leader>di dap.step_into         "Step Into")
              (bkset :n :<leader>dp dap.pause             "Pause")
              (bkset :n :<leader>dr dap.repl.toggle       "Toggle REPL")
              (bkset :n :<leader>ds dap.session           "Session")
              (bkset :n :<leader>dx dap.terminate         "Terminate")

              (let [dapui (require "dapui")]
                (dapui.setup)

                (vim.api.nvim_create_autocmd
                  :FileType
                  {:pattern "dapui_console"
                   :group    (vim.api.nvim_create_augroup :DapUI {:clear true})
                   :callback (fn [_ b]
                               (bkset :n :j dap.step_over {:desc "Step Over" :buffer b}))})

                (bkset :n :<leader>dd dapui.toggle "toggle")
                (bkset :n :<leader>de dapui.eval "eval")

                ; (tset dap.listeners.after.event_initialized :dapui_config
                ;       (fn [] (dapui.open {})))
                (tset dap.listeners.before.event_terminated :dapui_config
                      (fn [] (dapui.close {})))
                (tset dap.listeners.before.event_exited :dapui_config (fn [] (dapui.close {}))))))}]

