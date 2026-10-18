-- [nfnl] fnl/plugins/go.fnl
return {{"ray-x/go.nvim", dependencies = {"ray-x/guihua.lua"}, lazy = true, ft = {"go", "gomod"}, opts = {textobjects = false}, event = {"CmdlineEnter"}, build = ":lua require(\"go.install\").update_all_sync()"}}
