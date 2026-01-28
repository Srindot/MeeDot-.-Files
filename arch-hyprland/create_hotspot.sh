#!/bin/bash

# Create a Wi-Fi hotspot with the updated settings and specify IP range
nmcli dev wifi hotspot ifname wlan0 ssid stimp password alpha_12 
# Show the password for the hotspot
nmcli dev wifi show-password

