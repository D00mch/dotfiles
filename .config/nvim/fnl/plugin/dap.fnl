(module plugin.dap
  {autoload {nvim aniseed.nvim
             ;null-ls null-ls

             dap dap
             dapui dapui
             dap-install dap-install
             debuggers dap-install.api.debuggers

             which plugin.which
             {: kset : bkset : vis-op+} util
             {: map : merge : update : first} aniseed.core
             {: lsp_references : lsp_implementations} telescope.builtin
             }})

(dap-install.setup {})
(dapui.setup {})

(each [_ debugger (ipairs (debuggers.get_installed_debuggers))]
  (dap-install.config debugger))

(kset :n :<leader>dc dap.continue :<dap>continue)
(kset :n :<leader>db dap.toggle_breakpoint :<dap>toggle_breakpoint)
