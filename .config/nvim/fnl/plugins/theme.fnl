(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset} (autoload :config.util))

(fn dark? [] (= nvim.o.background "dark"))
(fn transparent? [] (< (or vim.g.neovide_opacity 1) 1))

(set vim.g.neovide_floating_blur_amount_x 2.0)
(set vim.g.neovide_floating_blur_amount_y 2.0)

(fn make-transparent []
  (set vim.g.neovide_opacity (if (dark?) 0.87 0.85))
  (set vim.g.neovide_window_blurred true))

(fn make-non-transparent []
  (set vim.g.neovide_opacity 1)
  (set vim.g.neovide_window_blurred false))

(local theme-defaults {:dark "suannhai-lam-ni" :light "suannhai-shironeri"})
(var appearance vim.o.background)

(fn theme-file [] (.. (vim.fn.stdpath :state) "/theme-" appearance))

(fn set-theme [mode]
  (set appearance mode)
  (let [path (theme-file)
        saved (if (= 1 (vim.fn.filereadable path)) (vim.fn.readfile path) [])
        name (or (. saved 1) (. theme-defaults mode))
        background (if (. theme-defaults (. saved 2)) (. saved 2) mode)]
    (when (or (not= vim.g.colors_name name) (not= vim.o.background background))
      (set vim.o.background background)
      (when (not (pcall vim.cmd.colorscheme name))
        (set vim.o.background mode)
        (vim.cmd.colorscheme (. theme-defaults mode)))))
  (when (transparent?) (make-transparent)))

(fn select-theme []
  (let [builtin (require :telescope.builtin)
        actions (require :telescope.actions)
        state (require :telescope.actions.state)
        path (theme-file)]
    (builtin.colorscheme
      {;; Only confirmed selections are saved; cancellation leaves the theme alone.
       :enable_preview false
       :attach_mappings
       (fn [prompt]
         (actions.select_default:replace
           (fn []
             (let [selection (state.get_selected_entry)]
               (when selection
                 (actions.close prompt)
                 (vim.cmd.colorscheme selection.value)
                 (when (transparent?) (make-transparent))
                 (vim.fn.mkdir (vim.fn.stdpath :state) "p")
                 (vim.fn.writefile [selection.value vim.o.background] path)))))
         true)})))


;;; font

;; Neovide hot-reloads this file and remembers the selection across restarts.
;; Keep guifont unset: setting it discards the custom Oblique faces.
(local font-config (or vim.env.NEOVIDE_CONFIG
                       (.. (or vim.env.XDG_CONFIG_HOME (vim.fn.expand "~/.config"))
                           "/neovide/config.toml")))
(local fonts [{:name "Maple Mono NF" :size 16}
              {:name "VictorMono Nerd Font Mono" :size 16 :italic "Oblique"}
              {:name "Terminalia" :size 19 :fallback "Terminess Nerd Font"}
              {:name "Hack Nerd Font Mono" :size 15}
              {:name "JetBrainsMonoNL Nerd Font Mono" :size 15}
              {:name "Iosevka Nerd Font Mono" :size 17}
              {:name "Iosevka Nerd Font Propo" :size 17}])

(fn current-font []
  (let [text (.. (table.concat (vim.fn.readfile font-config) "\n") "\n[")
        config (or (text:match "%[font%]%s*\n(.-)\n%[") "")
        family (config:match "normal%s*=%s*%[%s*\"([^\"]+)\"")]
    (var font (. fonts 1))
    (each [_ candidate (ipairs fonts)]
      (when (= candidate.name family) (set font candidate)))
    (values font (or (tonumber (config:match "\nsize%s*=%s*([%d.]+)")) font.size))))

(fn set-font! [font size]
  (if (not vim.g.neovide)
    (vim.notify "Font switching requires Neovide" vim.log.levels.INFO)
    (let [families (vim.json.encode [font.name font.fallback])
          face (fn [style]
                 (if font.italic
                   (string.format "[{ family = \"%s\", style = \"%s\" }]" font.name style)
                   families))
          settings {:normal families :bold families
                    :italic (face font.italic)
                    :bold_italic (face (.. "Bold " (or font.italic "Italic")))
                    :size (tostring (or size font.size))}
          lines []]
      (var in-font? false)
      ;; Update only the picker-managed keys, preserving other configuration.
      (each [_ line (ipairs (vim.fn.readfile font-config))]
        (when (line:match "^%[") (set in-font? (= line "[font]")))
        (when (not (and in-font? (. settings (or (line:match "^([%w_]+)%s*=") ""))))
          (table.insert lines line))
        (when (= line "[font]")
          (each [_ key (ipairs [:normal :bold :italic :bold_italic :size])]
            (table.insert lines (.. key " = " (. settings key))))))
      (vim.fn.writefile lines font-config))))

(fn select-font []
  (require :telescope)
  (vim.ui.select fonts
                 {:prompt "Font"
                  :format_item #(string.format "%s (%d pt)" $.name $.size)}
                 #(when $ (set-font! $))))

(fn font-size! [diff]
  (let [(font size) (current-font)]
    (set-font! font (math.max 1 (+ size diff)))))

[{1 :f-person/auto-dark-mode.nvim
  :lazy false
  :priority 1000
  :dependencies [:nvim-tree/nvim-web-devicons]
  :init (fn []
          (when vim.g.neovide
            (make-transparent)
            (set nvim.g.neovide_cursor_vfx_mode "pixiedust")
            (set nvim.g.neovide_input_macos_option_key_is_meta "none")
            (kset :n :<Space>tt
                    #(if (transparent?)
                       (make-non-transparent)
                       (make-transparent))
                    "transparency"))

          (kset :n :<D-+> #(font-size! 1))
          (kset :n :<D--> #(font-size! -1))
          (kset :n :<leader>sd #(let [font (current-font)] (set-font! font)) "Default font size")
          (kset :n :<Space>vf select-font "Select font")
          (vim.api.nvim_create_user_command :Font select-font {:desc "Select font"})
          (kset :n :<Space>vc select-theme "Select theme")
          (vim.api.nvim_create_user_command :Theme select-theme {:desc "Select theme"})

          ;;; removing `~` shit in empty files
          (set vim.opt.fillchars { :eob " "}))
  :config (fn []
            (vim.api.nvim_create_autocmd :FocusGained
              {:group (vim.api.nvim_create_augroup :SavedTheme {:clear true})
               :callback (fn [] (set-theme appearance))})
            (let [auto (require :auto-dark-mode)]
              (auto.setup
                {:update_interval 2000
                 :set_dark_mode #(set-theme :dark)
                 :set_light_mode #(set-theme :light)})))}]
