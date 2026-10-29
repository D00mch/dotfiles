-- [nfnl] fnl/plugins/theme.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local nvim = autoload("nvim")
local _local_2_ = autoload("config.util")
local kset = _local_2_.kset
local function dark_3f()
  return (nvim.o.background == "dark")
end
local function transparent_3f()
  return ((vim.g.neovide_opacity or 1) < 1)
end
vim.g.neovide_floating_blur_amount_x = 2
vim.g.neovide_floating_blur_amount_y = 2
local function make_transparent()
  if dark_3f() then
    vim.g.neovide_opacity = 0.87
  else
    vim.g.neovide_opacity = 0.85
  end
  vim.g.neovide_window_blurred = true
  return nil
end
local function make_non_transparent()
  vim.g.neovide_opacity = 1
  vim.g.neovide_window_blurred = false
  return nil
end
local theme_defaults = {dark = "suannhai-lam-ni", light = "suannhai-shironeri"}
local appearance = vim.o.background
local function theme_file()
  return (vim.fn.stdpath("state") .. "/theme-" .. appearance)
end
local function set_theme(mode)
  appearance = mode
  do
    local path = theme_file()
    local saved
    if (1 == vim.fn.filereadable(path)) then
      saved = vim.fn.readfile(path)
    else
      saved = {}
    end
    local name = (saved[1] or theme_defaults[mode])
    local background
    if theme_defaults[saved[2]] then
      background = saved[2]
    else
      background = mode
    end
    if ((vim.g.colors_name ~= name) or (vim.o.background ~= background)) then
      vim.o.background = background
      if not pcall(vim.cmd.colorscheme, name) then
        vim.o.background = mode
        vim.cmd.colorscheme(theme_defaults[mode])
      else
      end
    else
    end
  end
  if transparent_3f() then
    return make_transparent()
  else
    return nil
  end
end
local function select_theme()
  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local state = require("telescope.actions.state")
  local path = theme_file()
  local function _9_(prompt)
    local function _10_()
      local selection = state.get_selected_entry()
      if selection then
        actions.close(prompt)
        vim.cmd.colorscheme(selection.value)
        if transparent_3f() then
          make_transparent()
        else
        end
        vim.fn.mkdir(vim.fn.stdpath("state"), "p")
        return vim.fn.writefile({selection.value, vim.o.background}, path)
      else
        return nil
      end
    end
    actions.select_default:replace(_10_)
    return true
  end
  return builtin.colorscheme({attach_mappings = _9_, enable_preview = false})
end
local font_config = (vim.env.NEOVIDE_CONFIG or ((vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")) .. "/neovide/config.toml"))
local fonts = {{name = "Maple Mono NF", size = 16}, {name = "VictorMono Nerd Font Mono", size = 16, italic = "Oblique"}, {name = "Terminalia", size = 19, fallback = "Terminess Nerd Font"}, {name = "Hack Nerd Font Mono", size = 15}, {name = "JetBrainsMonoNL Nerd Font Mono", size = 15}, {name = "Iosevka Nerd Font Mono", size = 17}, {name = "Iosevka Nerd Font Propo", size = 17}}
local function current_font()
  local text = (table.concat(vim.fn.readfile(font_config), "\n") .. "\n[")
  local config = (text:match("%[font%]%s*\n(.-)\n%[") or "")
  local family = config:match("normal%s*=%s*%[%s*\"([^\"]+)\"")
  local font = fonts[1]
  for _, candidate in ipairs(fonts) do
    if (candidate.name == family) then
      font = candidate
    else
    end
  end
  return font, (tonumber(config:match("\nsize%s*=%s*([%d.]+)")) or font.size)
end
local function set_font_21(font, size)
  if not vim.g.neovide then
    return vim.notify("Font switching requires Neovide", vim.log.levels.INFO)
  else
    local families = vim.json.encode({font.name, font.fallback})
    local face
    local function _14_(style)
      if font.italic then
        return string.format("[{ family = \"%s\", style = \"%s\" }]", font.name, style)
      else
        return families
      end
    end
    face = _14_
    local settings = {normal = families, bold = families, italic = face(font.italic), bold_italic = face(("Bold " .. (font.italic or "Italic"))), size = tostring((size or font.size))}
    local lines = {}
    local in_font_3f = false
    for _, line in ipairs(vim.fn.readfile(font_config)) do
      if line:match("^%[") then
        in_font_3f = (line == "[font]")
      else
      end
      if not (in_font_3f and settings[(line:match("^([%w_]+)%s*=") or "")]) then
        table.insert(lines, line)
      else
      end
      if (line == "[font]") then
        for _0, key in ipairs({"normal", "bold", "italic", "bold_italic", "size"}) do
          table.insert(lines, (key .. " = " .. settings[key]))
        end
      else
      end
    end
    return vim.fn.writefile(lines, font_config)
  end
end
local function select_font()
  require("telescope")
  local function _20_(_241)
    return string.format("%s (%d pt)", _241.name, _241.size)
  end
  local function _21_(_241)
    if _241 then
      return set_font_21(_241)
    else
      return nil
    end
  end
  return vim.ui.select(fonts, {prompt = "Font", format_item = _20_}, _21_)
end
local function font_size_21(diff)
  local font, size = current_font()
  return set_font_21(font, math.max(1, (size + diff)))
end
local function _23_()
  if vim.g.neovide then
    make_transparent()
    nvim.g.neovide_cursor_vfx_mode = "pixiedust"
    nvim.g.neovide_input_macos_option_key_is_meta = "none"
    local function _24_()
      if transparent_3f() then
        return make_non_transparent()
      else
        return make_transparent()
      end
    end
    kset("n", "<Space>tt", _24_, "transparency")
  else
  end
  local function _27_()
    return font_size_21(1)
  end
  kset("n", "<D-+>", _27_)
  local function _28_()
    return font_size_21(-1)
  end
  kset("n", "<D-->", _28_)
  local function _29_()
    local font = current_font()
    return set_font_21(font)
  end
  kset("n", "<leader>sd", _29_, "Default font size")
  kset("n", "<Space>vf", select_font, "Select font")
  vim.api.nvim_create_user_command("Font", select_font, {desc = "Select font"})
  kset("n", "<Space>vc", select_theme, "Select theme")
  vim.api.nvim_create_user_command("Theme", select_theme, {desc = "Select theme"})
  vim.opt.fillchars = {eob = " "}
  return nil
end
local function _30_()
  local function _31_()
    return set_theme(appearance)
  end
  vim.api.nvim_create_autocmd("FocusGained", {group = vim.api.nvim_create_augroup("SavedTheme", {clear = true}), callback = _31_})
  local auto = require("auto-dark-mode")
  local function _32_()
    return set_theme("dark")
  end
  local function _33_()
    return set_theme("light")
  end
  return auto.setup({update_interval = 2000, set_dark_mode = _32_, set_light_mode = _33_})
end
return {{"f-person/auto-dark-mode.nvim", priority = 1000, dependencies = {"nvim-tree/nvim-web-devicons"}, init = _23_, config = _30_, lazy = false}}
