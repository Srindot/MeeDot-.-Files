# Dot Files for Hyprland Arch Experience
This repository contains my **dotfiles** for my Windows, and Arch system.


## Devices  
- **WSL-arch**: Windows Subsystem for Linux (Arch Distro)
- **Windows**: Windows Config files 
- **Arch Hyprland IGPU**: Arch linux with Hyprland on IGPU. 
- **Arch Hyprland DGPU**: Arch linux with Hyprland on DGPU. 


---
## Packages Configs

The following package configs are available in this repository.

### In Arch Linux
- **Kitty**
- **Hyprland suite** ( Hyprland, Hyprpaper, Hypridle, Hyprlock)
- **btop**
- **eww**
- **fastfetch** 
- **nvim** 
- **rofi**
- **starship**
- **tmux**
- **waybar**

### In WSL
- **btop**
- **fastfetch**
- **nvim**
- **starship**
- **tmux**

### In Windows 
- **AHK**
- **Komorebi**
- **Yasb**

## Quick Set Up 

#### Clone the repository:

```bash
git clone https://github.com/Srindot/MeeDot-.-Files.git
cd hyprland-dotfiles
```
### Linux & Wsl

For easy setup in linux and wsl, install GNU Stow for easy deployment through symbolic links:

#### Install GNU Stow

Make sure GNU Stow is installed:

```bash
sudo pacman -S stow  # Arch-based systems

```
#### Deploy Dotfiles with Stow

Run the following command to deploy the dotfile through symlink :

```bash
stow hyprland waybar rofi nvim kitty

```
### Windows 

For windows, there is no working stow alternative. Set up the symbolic links manually following the powershell commands.

