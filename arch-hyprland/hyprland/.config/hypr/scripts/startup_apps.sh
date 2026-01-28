#!/bin/bash
# To kill swaync session such that hyprpanel can be resurrected
sleep 1
killall swaync

hyprctl dispatch workspace 1
sleep 1 # Give time for the switch
spotify-launcher &
sleep 1
elecwhat
sleep 3

# Switch to workspace 2 and launch Vivaldi
hyprctl dispatch workspace 2
sleep 1 # Give time for the switch
floorp	
sleep 2

# Switch to workspace 3 and launch Kitty
hyprctl dispatch workspace 3
sleep 1 # Give time for the switch
kitty --hold -e fastfetch &
sleep 2

# Switch to workspace 3 and launch Kitty
hyprctl dispatch workspace 4	
sleep 1 # Give time for the switch
obsidian &
