-- [nfnl] fnl/plugins/nvim-tree.fnl
local _local_1_ = require("config.util")
local kset = _local_1_.kset
local bkset = _local_1_.bkset
local bkdel = _local_1_.bkdel
local function _2_()
  kset("n", "<space>pt", ":NvimTreeOpen<cr>")
  return kset("n", "<space>m", ":NvimTreeOpen<cr>")
end
local function _3_()
  local tree = require("nvim-tree")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local api = require("nvim-tree.api")
  local openfile = require("nvim-tree.actions.node.open-file")
  local view_selection
  local function _4_(prompt_bufnr, _)
    local function _5_()
      local selection = action_state.get_selected_entry()
      if selection then
        actions.close(prompt_bufnr)
        local function _6_()
          local filename = (selection.path or selection.filename or selection[1])
          openfile.fn("edit", filename)
          if (selection.lnum and (filename == vim.api.nvim_buf_get_name(0))) then
            return vim.api.nvim_win_set_cursor(0, {selection.lnum, math.max(0, ((selection.col or 1) - 1))})
          else
            return nil
          end
        end
        return vim.schedule(_6_)
      else
        return nil
      end
    end
    actions.select_default:replace(_5_)
    return true
  end
  view_selection = _4_
  local launch_telescope
  local function _9_(fun_name)
    local node = api.tree.get_node_under_cursor()
    local folder_3f = (node.fs_stat and (node.fs_stat.type == "directory"))
    local basedir = ((folder_3f and node.absolute_path) or vim.fn.fnamemodify(node.absolute_path, ":h"))
    local basedir0
    if ((node.name == "..") and (TreeExplorer ~= nil)) then
      basedir0 = TreeExplorer.cwd
    else
      basedir0 = basedir
    end
    local f = require("telescope.builtin")[fun_name]
    return f({cwd = basedir0, search_dirs = {basedir0}, attach_mappings = view_selection})
  end
  launch_telescope = _9_
  local function _11_()
    return api.tree.toggle(false, true)
  end
  kset("n", "<space>pt", _11_, "Tree Toggle")
  local function _12_()
    api.tree.toggle()
    if api.tree.is_visible() then
      return api.tree.collapse_all(true)
    else
      return nil
    end
  end
  kset("n", "<Space>m", _12_, "Collapse and show")
  local function _14_(b)
    api.config.mappings.default_on_attach(b)
    bkdel("n", "q", b)
    local function _15_()
      return launch_telescope("live_grep")
    end
    bkset("n", "S", _15_, b)
    local function _16_()
      return launch_telescope("find_files")
    end
    bkset("n", "<D-S-f>", _16_, b)
    local function _17_()
      return vim.cmd(("wincmd l" .. "|" .. "BufferLineCyclePrev"))
    end
    bkset("n", "<D-,>", _17_, b)
    local function _18_()
      return vim.cmd(("wincmd l" .. "|" .. "BufferLineCycleNext"))
    end
    bkset("n", "<D-.>", _18_, b)
    local function _19_()
      return vim.cmd("NvimTreeResize +5")
    end
    bkset("n", "<M-.>", _19_, b)
    local function _20_()
      return vim.cmd("NvimTreeResize -5")
    end
    bkset("n", "<M-,>", _20_, b)
    bkset("n", "gal", api.node.open.vertical, b)
    bkset("n", "gak", api.node.open.horizontal, b)
    bkset("n", "gaj", api.node.open.horizontal, b)
    bkset("n", "(", api.node.navigate.parent, b)
    bkset("n", "sd", api.tree.change_root_to_node, {buffer = b, desc = "Set root"})
    bkset("n", "gx", api.node.run.system, {buffer = b, desc = "Open system default"})
    bkset("n", "<Space>sd", api.tree.change_root_to_node, {buffer = b, desc = "Set root"})
    bkset("n", "gf", api.node.run.system, b)
    bkset("n", "i", api.node.show_info_popup, b)
    local function _21_()
      local win = vim.fn.bufwinid(b)
      if (win ~= -1) then
        return api.tree.resize({absolute = vim.api.nvim_win_get_width(win)})
      else
        return nil
      end
    end
    return vim.api.nvim_create_autocmd("BufWinLeave", {buffer = b, callback = _21_})
  end
  return tree.setup({sync_root_with_cwd = true, update_focused_file = {enable = true, update_root = true}, git = {enable = false}, actions = {open_file = {resize_window = false}}, on_attach = _14_, renderer = {indent_markers = {enable = true}, symlink_destination = false}, filters = {custom = {"^.git$"}}, respect_buf_cwd = false})
end
return {{"nvim-tree/nvim-tree.lua", lazy = true, cmd = {"NvimTreeOpen", "NvimTreeClose", "NvimTreeToggle"}, event = "VeryLazy", dependencies = {"nvim-tree/nvim-web-devicons"}, init = _2_, config = _3_}}
