-- [nfnl] Compiled from fnl/plugins/gp.fnl by https://github.com/Olical/nfnl, do not edit.
local has_key = os.getenv("OPENAI_API_KEY")
local function map_key_bindings()
  local wk = require("which-key")
  local _let_1_ = require("config.util")
  local kset = _let_1_["kset"]
  wk.add({"<space>c", group = "gpt"})
  kset("n", "<space>cf", ":GpChatFinder<cr>", "Finder")
  kset("n", "<space>cr", ":GpChatRespond<cr>", "Respond")
  kset("n", "<space>cs", ":GpStop<cr>", "Stop")
  kset("n", "<space>cb", ":GpChatBackend<cr>", "Backend")
  kset("n", "<space>cg", ":GpChatGrammar<cr>", "Grammar")
  kset("n", "<space>ci", ":GpChatIT<cr>", "IT")
  return kset("n", "<space>ct", ":GpChatTranslator<cr>", "Translator")
end
local gp_hooks
local function _2_(gp, params)
  local chat_system_prompt = "You are a Translator, translate between English and Russian"
  return gp.cmd.ChatNew(params, chat_system_prompt)
end
local function _3_(gp, params)
  local chat_system_prompt = os.getenv("BACKEND_PROMPT")
  return gp.cmd.ChatNew(params, chat_system_prompt)
end
local function _4_(gp, params)
  local chat_system_prompt = os.getenv("GRAMMAR_PROMPT")
  return gp.cmd.ChatNew(params, chat_system_prompt)
end
local function _5_(gp, params)
  local chat_system_prompt = os.getenv("IT_PROMPT")
  return gp.cmd.ChatNew(params, chat_system_prompt)
end
gp_hooks = {ChatTranslator = _2_, ChatBackend = _3_, ChatGrammar = _4_, ChatIT = _5_}
local function _6_()
  local gp = require("gp")
  local defaults = require("gp.defaults")
  map_key_bindings()
  return gp.setup({chat_shortcut_respond = {modes = {"n"}, shortcut = "<leader>b"}, chat_shortcut_stop = {modes = {"n"}, shortcut = "<leader>x"}, hooks = gp_hooks, image = {prompt_save = "\240\159\150\140\239\184\143\240\159\146\190 ~ ", store_dir = (os.getenv("HOME") .. "/Downloads/")}, agents = {{name = "gpt-4o", chat = true, model = {model = "gpt-4o", temperature = 1.1, top_p = 1}, system_prompt = defaults.chat_system_prompt}}})
end
return {{"Robitx/gp.nvim", lazy = true, event = "VeryLazy", cond = has_key, config = _6_}}
