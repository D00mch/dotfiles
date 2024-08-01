-- [nfnl] Compiled from ftplugin/clojure.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local println = _local_2_["println"]
local kset = _local_2_["kset"]
local bkset = _local_2_["bkset"]
local _local_3_ = autoload("nfnl.core")
local some = _local_3_["some"]
nvim.g.surround_99 = "#_\13"
local run_lein_cmd = "lein repl"
local run_deps_cmd = "clj -M:local-nrepl:add-libs"
local run_flutter_cmd = "clj -M -m cljd.build flutter"
local function run_appropriate_clojure_repl()
  local root_files = nvim.fn.readdir(nvim.fn.getcwd())
  local has_pubspec
  local function _4_(_241)
    return (_241 == "pubspec.yaml")
  end
  has_pubspec = some(_4_, root_files)
  local has_lein
  local function _5_(_241)
    return (_241 == "project.clj")
  end
  has_lein = some(_5_, root_files)
  local has_deps
  local function _6_(_241)
    return (_241 == "deps.edn")
  end
  has_deps = some(_6_, root_files)
  if has_pubspec then
    nvim.echo("found flutter")
    return vim.api.nvim_command(("terminal " .. run_flutter_cmd))
  elseif has_lein then
    nvim.echo("found lein")
    return vim.api.nvim_command(("terminal " .. run_lein_cmd))
  elseif has_deps then
    nvim.echo("found deps")
    return vim.api.nvim_command(("terminal " .. run_deps_cmd))
  else
    return nvim.echo("can't find neither deps.edn nor project.clj in the root")
  end
end
local function connect_shadow()
  println("Connecting to 7002:app")
  vim.cmd(("ConjureConnect " .. 7002))
  vim.cmd("sleep 1")
  return vim.cmd(("ConjureShadowSelect " .. "app"))
end
local function set_up_mappings()
  bkset("n", "<Leader>rs", connect_shadow, "Shadow REPL:7002:app")
  bkset("n", "<Leader>c", "ysafc", {remap = true})
  bkset("n", "<Leader>uc", "<Cmd>let s=@/<CR>l?\\v(#_)+<CR>dgn:let @/=s<CR>")
  return bkset("n", "<Leader>k", run_appropriate_clojure_repl)
end
return set_up_mappings()
