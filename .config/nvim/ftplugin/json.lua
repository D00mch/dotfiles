-- [nfnl] Compiled from ftplugin/json.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local line = vim.api.nvim_get_current_line()
  local should_add_comma = string.find(line, "[^,{[]$")
  if should_add_comma then
    return "A,<cr>"
  else
    return "o"
  end
end
return vim.keymap.set("n", "o", _1_, {buffer = true, expr = true})
