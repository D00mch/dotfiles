-- [nfnl] fnl/config/misc.fnl
local root_names = {".git", "Makefile"}
local root_cache = {}
local function set_root()
  local path = vim.api.nvim_buf_get_name(0)
  if (path == "") then
    return 
  else
  end
  path = vim.fs.dirname(path)
  local root = root_cache[path]
  if (root == nil) then
    local root_file = vim.fs.find(root_names, {path = path, upward = true})[1]
    if (root_file == nil) then
      return 
    else
    end
    root = vim.fs.dirname(root_file)
    root_cache[path] = root
  else
  end
  return vim.fn.chdir(root)
end
local root_augroup = vim.api.nvim_create_augroup("MyAutoRoot", {})
return vim.api.nvim_create_autocmd("BufEnter", {callback = set_root, group = root_augroup})
