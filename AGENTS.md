# Agent Notes

When doing a refactoring, prefer removing more lines of code than you add.

## Repository Shape

This is a personal macOS dotfiles and bootstrap repository, not an application or library. Keep edits narrow and tool-specific; many keybindings and machine assumptions are intentional.

Important entry points:

- `first_init.sh` performs first-machine setup. It accepts the dotfiles repo path as its first argument, defaults to `~/dotfiles`, installs Homebrew packages and casks, removes existing `~/.zshenv` and `~/.zshrc`, then delegates symlink setup to `init.sh`.
- `init.sh` symlinks most dotfiles into `$HOME` and `~/.config`, copies `.config/zathura`, and links Neovim spell data into `.config/nvim/spell`.
- `deinit.sh` removes known symlinks created by `init.sh`; keep it in sync when adding new symlinked config directories.
- `README.md` is the short human-facing overview.
- `INFO.md` is a longer repository map for humans and LLMs; update it when top-level details change.

## Current Tooling

The repo currently manages configs for Neovim, Vim, IdeaVim, Neovide, WezTerm, Karabiner/Goku, AeroSpace, Neru, Sioyek, Vimium C, Clojure tooling, and helper scripts.

Neru-specific notes:

- `first_init.sh` taps `y3owk1n/tap` and installs `y3owk1n/tap/neru`.
- `init.sh` symlinks `.config/neru` into `~/.config/neru`.
- `deinit.sh` should remove `~/.config/neru` together with the other generated symlinks.
- Karabiner maps `Command+Right Command+f` to `Command+Shift+Space` for Neru hints and `Command+Right Command+a` to `Command+Shift+g` for Neru grid mode.

## Editing Guidance

- Prefer `rg` for file and text searches.
- Use `apply_patch` for manual edits.
- Do not rewrite generated Karabiner JSON by hand unless the corresponding `.config/karabiner.edn` source is also understood.
- Treat generated or stateful directories carefully, especially `.config/nvim/data/` and `.config/karabiner/automatic_backups/`.
- Preserve personal workflow choices unless the request is explicitly about portability or cleanup.

## Validation

For bootstrap/init edits, at minimum run:

```bash
bash -n first_init.sh init.sh deinit.sh
```

For Karabiner changes, validate JSON with:

```bash
jq empty .config/karabiner/karabiner.json
```

For Neru config changes, validate TOML syntax with:

```bash
python3 -c 'import tomllib; tomllib.load(open(".config/neru/config.toml", "rb"))'
```
