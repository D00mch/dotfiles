-- [nfnl] fnl/plugins/lualine.fnl
return {{"nvim-lualine/lualine.nvim", opts = {sections = {lualine_b = {{"filename", path = 1}}, lualine_a = {"branch"}, lualine_c = {"lsp_status"}, lualine_x = {"encoding", "filetype"}}}, config = true}}
