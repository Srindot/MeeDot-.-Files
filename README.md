# Dot Files for Hyprland Arch Experience

This repository contains **dotfiles** for my devices


## Devices
- **WSL_arch**
- **Windows**
- **Arch Hyprland**

##  Installation

Easily replicate this setup on any system using **GNU Stow**.

### **1️⃣ Clone the Repository**

```bash
git clone https://github.com/Srindot/MeeDot-.-Files.git
cd hyprland-dotfiles
```

2️⃣ Install GNU Stow

Make sure GNU Stow is installed:

```bash
sudo pacman -S stow  # Arch-based systems
```

3️⃣ Deploy Dotfiles with Stow
Run the following command to symlink the configurations:

```bash
stow hyprland waybar rofi nvim kitty
```

This will correctly symlink the dotfiles into your ~/.config directory.

