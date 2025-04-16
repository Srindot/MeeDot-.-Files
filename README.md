# Hyprland Dot Files

This repository contains my **dotfiles** for configuring the **Hyprland Window Manager** on an **Arch Linux** system. It includes essential configuration files for a **personalized and streamlined** desktop experience.

## 🚀 Features

- **Hyprland WM** – Optimized tiling and workspace management
- **Waybar** – Customized status bar with system monitoring
- **Kitty & Neovim** – Performance-focused terminal and text editor setup
- **Rofi** – Aesthetic and efficient application launcher
- **GNU Stow** – Simplified dotfile management and replication across systems

## 📦 Included Software Packages

This repository provides configuration files for the following software:

- **Hyprland** – A dynamic tiling Wayland compositor
  ![Alt text]()
- **Waybar** – A highly customizable status bar
- **Kitty** – A fast, GPU-based terminal emulator
- **Neovim** – A lightweight, extensible text editor
- **Rofi** – An application launcher, window switcher, and dmenu replacement
- **GNU Stow** – A symlink manager for organizing dotfiles
- **Shell Configuration (`bashrc`, `zshrc`)** – Custom shell settings and aliases

## 📂 Installation

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

## Auto Setup

### 📌 Prerequisites

Make sure you have:

- **Arch Linux** installed
- **Hyprland** set up
- **GNU Stow** installed (`pacman -S stow`)

### 🔧 Installation

Clone the repository and run the setup script:

```bash
git clone https://github.com/Srindot/MeeDot-.-Files.git
cd YOUR_REPO
chmod +x setup.sh
./setup.sh
```

🔧 Customization
Feel free to modify any config files in hyprland-dotfiles/ to match your workflow.
