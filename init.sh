#!/usr/bin/env bash

DOTFILES_PATH=~/dotfiles


ln    -s   $DOTFILES_PATH/.vim                       ~/ 
ln    -s   $DOTFILES_PATH/.vimrc                     ~/
ln    -s   $DOTFILES_PATH/.zshenv                    ~/
ln    -s   $DOTFILES_PATH/.zshrc                     ~/
ln    -s   $DOTFILES_PATH/.ideavimrc                 ~/ 
ln    -s   $DOTFILES_PATH/fuz.sh                     ~/ 
ln    -s   $DOTFILES_PATH/.yabairc                   ~/ 
ln    -s   $DOTFILES_PATH/.skhdrc                    ~/ 

touch ~/.ssh-aliases.sh # zshrc source it

mkdir -p   ~/.config

ln    -s   $DOTFILES_PATH/.config/nvim               ~/.config/
ln    -s   $DOTFILES_PATH/.config/zathura            ~/.config/

mkdir -p   ~/.config/karabiner/
ln    -s   $DOTFILES_PATH/.config/karabiner/assets   ~/.config/karabiner/ 
