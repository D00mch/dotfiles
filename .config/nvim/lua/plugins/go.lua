-- [nfnl] Compiled from fnl/plugins/go.fnl by https://github.com/Olical/nfnl, do not edit.
return {{"ray-x/go.nvim", dependencies = {"ray-x/guihua.lua"}, lazy = true, ft = {"go", "gomod"}, config = {textobjects = false}, event = {"CmdlineEnter"}, build = ":lua require(\"go.install\").update_all_sync()"}}
