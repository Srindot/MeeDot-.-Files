# Hyprland Dot Files
This repository contains my dotfiles for configuring the Hyprland Window Manager on an Arch Linux system. It includes essential configuration files for creating a customized Hyprland setup.

## 📦 Included Software Packages
This repository contains configuration files for the following software:

- **Hyprland** - A dynamic tiling Wayland compositor  
- **Waybar** - A highly customizable status bar  
- **Kitty** - A fast GPU-based terminal emulator  
- **Neovim** - A powerful, extensible text editor  
- **Rofi** - A window switcher, application launcher, and dmenu replacement  
- **bashrc** - A feature-rich shell with plugins and themes  

### 🚀 Features
Hyprland WM configuration for tiling and dynamic workspace management

Waybar customization for an aesthetic and informative status bar

Alacritty/Kitty terminal settings optimized for performance

Rofi for application launching with custom themes

Neovim setup for coding and efficient text editing

GNU Stow for easy dotfile management and replication across multiple systems

### 📂 Installation
You can quickly replicate this setup on any system using GNU Stow.

1️⃣ Clone the Repository
```bash
git clone https://github.com/yourusername/hyprland-dotfiles.git
cd hyprland-dotfiles
```
2️⃣ Install GNU Stow

Make sure GNU Stow is installed:

``` bash
sudo pacman -S stow  # Arch-based systems
```
3️⃣ Deploy Dotfiles with Stow
Run the following command to symlink the configurations:

```bash
stow -v -t ~/.config hyprland waybar rofi nvim kitty
```

This will correctly symlink the dotfiles into your ~/.config directory.

🔧 Customization
Feel free to modify any config files in hyprland-dotfiles/ to match your workflow. Tweaks in hyprland.conf, waybar.json, and rofi.rasi can improve themes, workspace behavior, and system appearance.