#!/bin/bash

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install necessary packages
echo "Installing required packages..."
while read -r package; do
  sudo pacman -S --noconfirm "$package"
done < packages.txt

# Stow configurations
echo "Applying dotfile configurations..."
stow bash
stow fastfetch
stow hyprland
stow images
stow kitty
stow nvim
stow rofi
stow waybar

echo "Setup complete!"
