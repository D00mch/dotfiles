-- [nfnl] fnl/plugins/markdown.fnl
local function heading_backgrounds()
  local normal = vim.api.nvim_get_hl(0, {name = "Normal", link = false})
  local background
  local or_1_ = normal.bg
  if not or_1_ then
    if (vim.o.background == "dark") then
      or_1_ = 2105376
    else
      or_1_ = 16777215
    end
  end
  background = or_1_
  local accent = (vim.api.nvim_get_hl(0, {name = "Title", link = false}).fg or normal.fg or 8421504)
  for level, alpha in ipairs({0.32, 0.25, 0.19, 0.14, 0.09, 0.05}) do
    local color = 0
    for _, shift in ipairs({16, 8, 0}) do
      local fg = (math.floor((accent / (2 ^ shift))) % 256)
      local bg = (math.floor((background / (2 ^ shift))) % 256)
      color = (color + (math.floor(((fg * alpha) + (bg * (1 - alpha)) + 0.5)) * (2 ^ shift)))
    end
    vim.api.nvim_set_hl(0, ("RenderMarkdownH" .. level .. "Bg"), {bg = color})
  end
  return nil
end
local function _3_()
  heading_backgrounds()
  return vim.api.nvim_create_autocmd("ColorScheme", {group = vim.api.nvim_create_augroup("MarkdownHeadingBackgrounds", {clear = true}), callback = heading_backgrounds})
end
return {{"MeanderingProgrammer/render-markdown.nvim", ft = {"markdown"}, dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"}, init = _3_, opts = {anti_conceal = {enabled = false}, render_modes = {"n", "c", "t"}, heading = {width = "full", position = "inline", icons = {"H\226\130\129 ", "H\226\130\130 ", "H\226\130\131 ", "H\226\130\132 ", "H\226\130\133 ", "H\226\130\134 "}, left_pad = 1, right_pad = 2, sign = false}, code = {width = "block", border = "thick", highlight = "CursorLine", highlight_border = "CursorLine", background_inset = 0, language_border = " ", language_pad = 1, language_left = " ", language_right = " ", left_pad = 2, right_pad = 2, disable_background = false, language_icon = false, sign = false}, bullet = {icons = {"\226\150\184", "\226\128\186", "\194\183"}}, checkbox = {left_pad = 1}, pipe_table = {preset = "round"}}, keys = {{"<Space>tv", "<cmd>RenderMarkdown buf_toggle<cr>", ft = "markdown", desc = "Toggle Markdown view"}}}}
