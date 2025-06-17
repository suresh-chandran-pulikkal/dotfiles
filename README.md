# CUSTOMIZED DOT FILES
🚀 This repo contains my personal configurations for various tools, terminal setups, and workflow optimizations for better productivity.

## 📜 Overview
This repository includes:
- **Neovim Configurations** (plugins, colorschemes, keybindings)
- **Terminal Enhancements** (Fish shell aliases, Lazygit setups)
- **Git Tools** (Lazygit, git configurations)
- **Tmux Configurations** (Tmux themes, Tmux plugins)
- **Miscellaneous Configurations** (.gitignore, aliases, etc.)


## 🔧 Installation
Clone the repository:
```bash
git clone https://github.com/suresh-chandran-pulikkal/dotfiles.git
cd dotfiles
```

## Using Stow for Dotfile Management
Install Stow:
```
sudo zypper install stow # Install Stow on openSUSE
sudo apt install stow # Install Stow on Ubuntu
sudo dnf install stow # Install Stow on Fedora
```
Use Stow to manage your dotfiles:
```bash
stow -t ~ tmux   # Apply Tmux configuration
stow -t ~ bash   # Apply Bash shell configuration
stow -t ~/.config/ nvim   # Apply Neovim configuration
stow -t ~/.config/ fish   # Apply Fish shell configuration
stow -t ~/.config/ gh     # Apply GitHub configuration
```

## 🛠 Features
- 🚀 Optimized Terminal & Editor Settings
- 🔍 Enhanced Observability Configurations
- 🔗 Efficient Git & Workflow Automation
- 📝 Neovim Custom Plugins & Keymaps
## 🌱 Contributing
If you'd like to contribute or suggest improvements:
- Fork the repository.
- Make your changes.
- Open a Pull Request.
## 📜 License
This repository is open-source and available under the MIT License.
## 📞 Contact
If you have any questions or ideas, feel free to connect!
Happy customizing! 🎨🛠
