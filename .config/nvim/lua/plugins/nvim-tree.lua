-- [nfnl] Compiled from .config/nvim/fnl/plugins/nvim-tree.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local actions = autoload("telescope.actions")
local action_state = autoload("telescope.actions.state")
local builtin = autoload("telescope.builtin")
local _local_2_ = autoload("nfnl.core")
local merge = _local_2_["merge"]
local _local_3_ = autoload("config.util")
local kset = _local_3_["kset"]
local bkset = _local_3_["bkset"]
local bkdel = _local_3_["bkdel"]
local function _4_()
  local tree = require("nvim-tree")
  local tree_view = require("nvim-tree.view")
  local lib = require("nvim-tree.lib")
  local api = require("nvim-tree.api")
  local openfile = require("nvim-tree.actions.node.open-file")
  local function _5_()
    return api.tree.toggle(false, true)
  end
  kset("n", "<space>pt", _5_, "Tree Toggle")
  local function _6_()
    api.tree.toggle()
    if tree_view.is_visible() then
      return api.tree.collapse_all(true)
    else
      return nil
    end
  end
  return kset("n", "<Space>1", _6_, "Collapse and show")
end
local function _8_()
  local tree = require("nvim-tree")
  local tree_view = require("nvim-tree.view")
  local lib = require("nvim-tree.lib")
  local api = require("nvim-tree.api")
  local openfile = require("nvim-tree.actions.node.open-file")
  local view_selection
  local function _9_(prompt_funr, map)
    local function _10_()
      actions.close(prompt_funr)
      local selection = action_state.get_selected_entry()
      local filename = (selection.filename or selection[1])
      return openfile.fn("preview", filename)
    end
    do end (actions.select_default):replace(_10_)
    return true
  end
  view_selection = _9_
  local launch_telescope
  local function _11_(fun_name)
    local node = api.tree.get_node_under_cursor()
    local folder_3f = (node.fs_stat and (node.fs_stat.type == "directory"))
    local basedir = ((folder_3f and node.absolute_path) or vim.fn.fnamemodify(node.absolute_path, ":h"))
    local basedir0
    if ((node.name == "..") and (TreeExplorer ~= nil)) then
      basedir0 = TreeExplorer.cwd
    else
      basedir0 = basedir
    end
    local f = builtin[fun_name]
    return f({cwd = basedir0, search_dirs = {basedir0}, attach_mappings = view_selection})
  end
  launch_telescope = _11_
  local function _13_(b)
    api.config.mappings.default_on_attach(b)
    bkdel("n", "q", b)
    local function _14_()
      return launch_telescope("live_grep")
    end
    bkset("n", "S", _14_, b)
    local function _15_()
      return launch_telescope("find_files")
    end
    bkset("n", "<D-S-f>", _15_, b)
    local function _16_()
      return vim.cmd(("wincmd l" .. "|" .. "BufferLineCyclePrev"))
    end
    bkset("n", "<D-,>", _16_, b)
    local function _17_()
      return vim.cmd(("wincmd l" .. "|" .. "BufferLineCycleNext"))
    end
    bkset("n", "<D-.>", _17_, b)
    local function _18_()
      return vim.cmd("NvimTreeResize +5")
    end
    bkset("n", "<M-.>", _18_, b)
    local function _19_()
      return vim.cmd("NvimTreeResize -5")
    end
    bkset("n", "<M-,>", _19_, b)
    bkset("n", "gal", api.node.open.vertical, b)
    bkset("n", "gak", api.node.open.horizontal, b)
    bkset("n", "gaj", api.node.open.horizontal, b)
    bkset("n", "(", api.node.navigate.parent, b)
    bkset("n", "sd", api.tree.change_root_to_node, b)
    bkset("n", "<Space>sd", api.tree.change_root_to_node, b)
    bkset("n", "gf", api.node.run.system, b)
    return bkset("n", "i", api.node.show_info_popup, b)
  end
  return tree.setup({sync_root_with_cwd = true, update_focused_file = {enable = true, update_root = true}, git = {enable = false}, on_attach = _13_, renderer = {indent_markers = {enable = true}, symlink_destination = false}, filters = {custom = {"^.git$"}}, respect_buf_cwd = false})
end
return {{"nvim-tree/nvim-tree.lua", dependencies = {"nvim-tree/nvim-web-devicons"}, init = _4_, config = _8_}}
