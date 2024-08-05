-- [nfnl] Compiled from fnl/plugins/dap.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("config.util")
local bkset = _local_2_["bkset"]
local wk = autoload("which-key")
vim.fn.sign_define("DapBreakpoint", {linehl = "DapBreakpoint", numhl = "DapBreakpoint", text = "\240\159\148\180", texthl = "DapBreakpointSymbol"})
vim.fn.sign_define("DapStopped", {linehl = "DapBreakpoint", numhl = "DapBreakpoint", text = "\240\159\148\180", texthl = "DapStoppedSymbol"})
local function _3_()
  do
    local mason = require("mason-nvim-dap")
    local dap_go = require("dap-go", "go")
    local dap_virtual = require("nvim-dap-virtual-text")
    mason.setup({ensure_installed = {"delve"}})
    dap_go.setup()
    dap_virtual.setup()
  end
  wk.add({"<leader>d", group = "Debug", desc = "+debug"})
  local dap = require("dap")
  bkset("n", "<leader>db", dap.toggle_breakpoint, "Toggle Breakpoint")
  bkset("n", "<leader>dc", dap.continue, "Continue")
  bkset("n", "<leader>da", dap.continue, "Run with Args")
  bkset("n", "<leader>dC", dap.run_to_cursor, "Run to Cursor")
  bkset("n", "<leader>dg", dap.goto_, "Go to Line (No Execute)")
  bkset("n", "<leader>dk", dap.up, "Up")
  bkset("n", "<leader>dl", dap.run_last, "Run Last")
  bkset("n", "<leader>dj", dap.step_over, "Step Over")
  bkset("n", "<leader>do", dap.step_out, "Step Out")
  bkset("n", "<leader>di", dap.step_into, "Step Into")
  bkset("n", "<leader>dp", dap.pause, "Pause")
  bkset("n", "<leader>dr", dap.repl.toggle, "Toggle REPL")
  bkset("n", "<leader>ds", dap.session, "Session")
  bkset("n", "<leader>dx", dap.terminate, "Terminate")
  local dapui = require("dapui")
  dapui.setup()
  local function _4_(_, b)
    return bkset("n", "j", dap.step_over, {desc = "Step Over", buffer = b})
  end
  vim.api.nvim_create_autocmd("FileType", {pattern = "dapui_console", group = vim.api.nvim_create_augroup("DapUI", {clear = true}), callback = _4_})
  bkset("n", "<leader>dd", dapui.toggle, "toggle")
  bkset("n", "<leader>de", dapui.eval, "eval")
  local function _5_()
    return dapui.close({})
  end
  dap.listeners.before.event_terminated["dapui_config"] = _5_
  local function _6_()
    return dapui.close({})
  end
  dap.listeners.before.event_exited["dapui_config"] = _6_
  return nil
end
return {{"mfussenegger/nvim-dap", dependencies = {"nvim-neotest/nvim-nio", "rcarriga/nvim-dap-ui", "jay-babu/mason-nvim-dap.nvim", "leoluz/nvim-dap-go", "theHamsta/nvim-dap-virtual-text"}, lazy = true, ft = {"go", "gomod"}, config = _3_}}
