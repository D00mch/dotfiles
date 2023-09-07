-- [nfnl] Compiled from .config/nvim/fnl/plugins/conjure.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local nvim = autoload("nvim")
local _local_2_ = autoload("config.which")
local toggle = _local_2_["toggle"]
local _local_3_ = autoload("config.util")
local kset = _local_3_["kset"]
local function toggle_log_mod()
  nvim.g["conjure#log#jump_to_latest#enabled"] = not nvim.g["conjure#log#jump_to_latest#enabled"]
  return nil
end
local function toggle_result_register()
  if (nvim.g["conjure#eval#result_register"] == "*") then
    nvim.g["conjure#eval#result_register"] = "r"
  else
    nvim.g["conjure#eval#result_register"] = "*"
  end
  return nil
end
local function _5_()
  nvim.g["conjure#log#wrap"] = true
  nvim.g["conjure#eval#result_register"] = "r"
  nvim.g["conjure#log#botright"] = true
  nvim.g["conjure#extract#tree_sitter#enabled"] = true
  nvim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
  nvim.g["conjure#eval#inline#prefix"] = "| "
  nvim.g["conjure#mapping#eval_visual"] = "q"
  nvim.g["conjure#mapping#eval_buf"] = "b"
  nvim.g["conjure#mapping#eval_root_form"] = "e"
  nvim.g["conjure#mapping#eval_word"] = "w"
  nvim.g["conjure#mapping#eval_marked_form"] = "m"
  nvim.g["conjure#mapping#eval_current_form"] = "q"
  nvim.g["conjure#mapping#eval_comment_current_form"] = ";"
  nvim.g["conjure#client#clojure#nrepl#mapping#interrupt"] = "i"
  nvim.g["conjure#mapping#eval_file"] = false
  nvim.g["conjure#mapping#eval_replace_form"] = false
  nvim.g["conjure#mapping#eval_comment_word"] = false
  nvim.g["conjure#mapping#eval_comment_root_form"] = false
  nvim.g["conjure#client#clojure#nrepl#mapping#refresh_all"] = false
  nvim.g["conjure#client#clojure#nrepl#mapping#refresh_changed"] = false
  kset({"n", "x", "i"}, "<D-l>", "<Leader>lg", {remap = true})
  nvim.g["conjure#log#jump_to_latest#enabled"] = true
  toggle("l", "conjure.log", toggle_log_mod)
  toggle("o", "conjure.output", toggle_result_register)
  nvim.g["conjure#client#clojure#nrepl#mapping#disconnect"] = false
  nvim.g["conjure#client#clojure#nrepl#mapping#connect_port_file"] = false
  kset("n", "<Leader>rd", "mZ\"8yieW\"9yie:ConjureEval (def <c-r>8 <c-r>9)<cr>`Z", {remap = true})
  nvim.g["conjure#client#racket#nrepl#eval#raw_out"] = true
  nvim.g["conjure#client#scheme#stdio#command"] = "csi -quiet -:c"
  nvim.g["conjure#client#scheme#stdio#prompt_pattern"] = "\n-#;%d-> "
  return nil
end
return {{"Olical/conjure", lazy = true, ft = {"clojure", "fennel"}, branch = "master", init = _5_}}
