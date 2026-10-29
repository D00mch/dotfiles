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
local function set_theme(dark_3f0)
  if dark_3f0 then
    nvim.o.background = "dark"
  else
    nvim.o.background = "light"
  end
  if transparent_3f() then
    make_transparent()
  else
  end
  local _6_
  if dark_3f0 then
    _6_ = "suannhai-lam-ni"
  else
    _6_ = "suannhai-shironeri"
  end
  return vim.api.nvim_command(("colorscheme " .. _6_))
end
local font_config = (vim.env.NEOVIDE_CONFIG or vim.fn.expand("~/.config/neovide/config.toml"))
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
    local function _9_(style)
      if font.italic then
        return string.format("[{ family = \"%s\", style = \"%s\" }]", font.name, style)
      else
        return families
      end
    end
    face = _9_
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
  local function _15_(_241)
    return string.format("%s (%d pt)", _241.name, _241.size)
  end
  local function _16_(_241)
    if _241 then
      return set_font_21(_241)
    else
      return nil
    end
  end
  return vim.ui.select(fonts, {prompt = "Font", format_item = _15_}, _16_)
end
local function font_size_21(diff)
  local font, size = current_font()
  return set_font_21(font, math.max(1, (size + diff)))
end
local function _18_()
  if vim.g.neovide then
    make_transparent()
    nvim.g.neovide_cursor_vfx_mode = "pixiedust"
    nvim.g.neovide_input_macos_option_key_is_meta = "none"
    local function _19_()
      if transparent_3f() then
        return make_non_transparent()
      else
        return make_transparent()
      end
    end
    kset("n", "<Space>tt", _19_, "transparency")
  else
  end
  local function _22_()
    return font_size_21(1)
  end
  kset("n", "<D-+>", _22_)
  local function _23_()
    return font_size_21(-1)
  end
  kset("n", "<D-->", _23_)
  local function _24_()
    local font = current_font()
    return set_font_21(font)
  end
  kset("n", "<leader>sd", _24_, "Default font size")
  kset("n", "<Space>vf", select_font, "Select font")
  vim.api.nvim_create_user_command("Font", select_font, {desc = "Select font"})
  vim.opt.fillchars = {eob = " "}
  return nil
end
local function _25_()
  local auto = require("auto-dark-mode")
  local function _26_()
    return set_theme(true)
  end
  local function _27_()
    return set_theme(false)
  end
  auto.setup({update_interval = 2000, set_dark_mode = _26_, set_light_mode = _27_})
  return auto.init()
end
return {{"f-person/auto-dark-mode.nvim", priority = 1000, dependencies = {"nvim-tree/nvim-web-devicons"}, init = _18_, config = _25_, lazy = false}}
