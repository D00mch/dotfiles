-- [nfnl] fnl/plugins/markdown.fnl
return {{"MeanderingProgrammer/render-markdown.nvim", ft = {"markdown"}, dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"}, opts = {anti_conceal = {enabled = false}, render_modes = {"n", "c", "t"}}, keys = {{"<Space>tv", "<cmd>RenderMarkdown buf_toggle<cr>", ft = "markdown", desc = "Toggle Markdown view"}}}}
