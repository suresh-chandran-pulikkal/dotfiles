#!/bin/bash

# Create necessary directories
mkdir -p ~/.config ~/.ssh

# Create symlinks
ln -sf ~/git/.dotfiles/nvim ~/.config/nvim
ln -sf ~/git/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/git/.dotfiles/bash/.bashrc ~/.bashrc
ln -sf ~/git/.dotfiles/ssh/config ~/.ssh/config

# Set proper permissions for SSH config
chmod 600 ~/.ssh/config

echo "Dotfiles installation complete!"
