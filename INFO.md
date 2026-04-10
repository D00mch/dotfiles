# Dotfiles

This repository contains personal macOS-oriented dotfiles, bootstrap scripts, and small helper utilities for shell, editor, terminal, keyboard, window-management, and browser/PDF workflows.

## Note for LLM

Keep this file updated whenever top-level details change.
If you are not sure about something, leave a note for other developers to review.

### Repository principles

- This is a config-and-bootstrap repository, not an application or library.
- Prefer narrow, tool-specific edits over broad cleanup. Personal keybindings and workflow choices are intentional.
- Preserve machine-specific assumptions unless the requested change is explicitly about setup portability.
- `first_init.sh` is invasive: it installs packages, removes existing `~/.zshenv` and `~/.zshrc`, then delegates to `init.sh`.
- `init.sh` symlinks most files into `$HOME` and `~/.config`, but copies `~/.config/zathura`.
- Treat generated or stateful directories carefully, especially `.config/nvim/data/` and `.config/karabiner/automatic_backups/`.

## Project Structure

```text
.
├── first_init.sh                         # Full bootstrap for a new machine
├── init.sh                               # Symlink/copy repo files into $HOME and ~/.config
├── README.md                             # Short human-facing overview
├── .zshenv                               # Environment setup
├── .zshrc                                # Interactive shell config
├── .wezterm.lua                          # WezTerm terminal config
├── .vimrc                                # Vim config entry point
├── .vim/                                 # Vim colors, keymaps, spell files, and local state dirs
├── .ideavimrc                            # JetBrains IdeaVim config
├── .skhdrc                               # skhd hotkey configuration
├── .clojure/                             # Clojure CLI and tool configs
├── .config/
│   ├── aerospace/                        # AeroSpace WM config and helper scripts for floating windows
│   ├── clj-kondo/                        # clj-kondo linter config
│   ├── karabiner/                        # Karabiner assets, docs, backups, and JSON config
│   ├── karabiner.edn                     # Goku source config for Karabiner generation
│   ├── nvim/                             # Neovim config in Lua/Fennel, snippets, ftplugins, lockfile
│   └── zathura/                          # Zathura PDF reader config
├── scripts/
│   ├── darkmode/                         # Small Go utility for toggling macOS/Chrome dark mode
│   ├── darkmode.sh                       # Shell wrapper for dark mode flow
│   ├── gpt.bash                          # Wi-Fi-aware shortcut that opens ChatGPT
│   ├── commit_notes.sh                   # Commit helper script
│   └── clj_scripts/                      # Standalone Clojure utilities/projects
├── resources/
│   ├── gpt/prompts.csv                   # Prompt-related data
│   ├── keyboard_data/                    # Keyboard layout image and JSON metadata
│   └── Alien_Ship_bg_vert_images/        # Bundled image assets
├── sioyek/                               # Sioyek PDF reader config
├── vimium-c/                             # Exported Vimium C browser config
├── idea/settings.zip                     # IntelliJ IDEA exported settings
├── android_studio/settings.zip           # Android Studio exported settings
└── .github/workflows/gitlab_sync.yml     # Mirrors pushes/deletes to GitLab
```
