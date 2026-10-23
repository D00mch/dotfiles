-- Run with: nvim --headless -u NONE -l /path/to/dotfiles/scripts/setup-nvim.lua
local repo = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local config = repo .. "/.config/nvim"
local data = vim.fn.stdpath("data")
local lock = vim.json.decode(table.concat(vim.fn.readfile(config .. "/lazy-lock.json"), "\n"))

assert(vim.uv.fs_realpath(vim.fn.stdpath("config")) == vim.uv.fs_realpath(config),
  "Link this checkout with init.sh before setting up Neovim")

local function run(command)
  local result = vim.system(command, { text = true }):wait()
  assert(result.code == 0, table.concat(command, " ") .. "\n" .. (result.stderr or "") .. (result.stdout or ""))
end

local function seed(name, repository)
  local path = data .. "/lazy/" .. name
  if not vim.uv.fs_stat(path) then
    print("Installing " .. name)
    assert(lock[name], "Missing plugin pin: " .. name)
    vim.fn.mkdir(data .. "/lazy", "p")
    run({ "git", "clone", "--filter=blob:none", "https://github.com/" .. repository .. ".git", path })
    run({ "git", "-C", path, "checkout", lock[name].commit })
  end
  vim.opt.runtimepath:prepend(path)
  return path
end

-- Plugin definitions require nfnl and nvim.lua before Lazy can discover them.
seed("lazy.nvim", "folke/lazy.nvim")
seed("nfnl", "Olical/nfnl")
seed("nvim.lua", "norcalli/nvim.lua")
local hererocks = seed("hererocks", "luarocks/hererocks")

-- Install the build backend in the LuaRocks runtime so REST's parser can build.
local rocks = data .. "/lazy-rocks/hererocks"
local luarocks = rocks .. "/bin/luarocks"
if vim.fn.executable(luarocks) ~= 1 then
  print("Installing Lua 5.1 and LuaRocks")
  run({ "python3", hererocks .. "/hererocks.py", "-l", "5.1", "-r", "3.13.0", rocks })
end
if not vim.uv.fs_stat(rocks .. "/share/lua/5.1/luarocks/build/treesitter-parser.lua") then
  run({ luarocks, "--tree", rocks, "--lua-version", "5.1", "install", "luarocks-build-treesitter-parser", "6.1.1" })
end

vim.opt.runtimepath:prepend(config)
vim.opt.loadplugins = true
dofile(config .. "/init.lua")
require("lazy").restore({ wait = true, show = false })
local lazy_config = require("lazy.core.config")
for _, notification in ipairs(lazy_config.spec.notifs) do
  assert(notification.level < vim.log.levels.ERROR, notification.msg)
end
for name, plugin in pairs(lazy_config.plugins) do
  assert(plugin._.installed, "Plugin was not installed: " .. name)
  assert(not require("lazy.core.plugin").has_errors(plugin), "Plugin installation failed: " .. name)
end

print("Installing configured Treesitter parsers")
local treesitter = require("nvim-treesitter")
local languages = lazy_config.plugins["nvim-treesitter"].opts.parsers
assert(treesitter.install(languages):wait(300000), "Treesitter parser installation failed")

local registry = require("mason-registry")
local refreshed, refresh_error = registry.refresh()
assert(refreshed, "Mason registry refresh failed: " .. vim.inspect(refresh_error))
local tools = {
  "clojure-lsp", "fennel-language-server", "gopls", "jdtls", "kotlin-lsp",
  "vtsls", "emmet-language-server", "ltex-ls", "basedpyright", "rust-analyzer", "delve",
}
local completed, failures = 0, {}
for _, name in ipairs(tools) do
  local package = registry.get_package(name)
  if package:is_installed() then
    completed = completed + 1
  else
    -- JetBrains' canonical endpoint supplies the signed redirect required by its CDN.
    if name == "kotlin-lsp" then
      for _, download in ipairs(package.spec.source.download) do
        for file, url in pairs(download.files) do
          download.files[file] = url:gsub("download%-cdn%.jetbrains%.com", "download.jetbrains.com")
        end
      end
    end
    print("Installing " .. name)
    package:install({}, function(success, err)
      if not success then failures[#failures + 1] = name .. ": " .. tostring(err) end
      completed = completed + 1
    end)
  end
end
assert(vim.wait(600000, function() return completed == #tools end, 100), "Mason installation timed out")
assert(#failures == 0, table.concat(failures, "\n"))

local trusted, trust_error = vim.secure.trust({ action = "allow", path = config .. "/.nfnl.fnl" })
assert(trusted, trust_error)
print("Neovim plugins, parsers, and language tools are ready")
