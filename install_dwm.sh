#!/bin/bash

set -e  # Exit on error

# Install necessary tools
sudo pacman -S --noconfirm xorg-xsetroot xorg-xrandr dmenu xclip

# Clone and build DWM, st, and dmenu
cd /usr/local/src
sudo git clone https://git.suckless.org/dwm
sudo git clone https://git.suckless.org/st
sudo git clone https://git.suckless.org/dmenu

# Build and install DWM
cd dwm
sudo make clean install

# Build and install st (simple terminal)
cd ../st
sudo make clean install

# Build and install dmenu
cd ../dmenu
sudo make clean install

# Create .xinitrc for starting DWM
echo "exec dwm" > ~/.xinitrc

echo "DWM, st, and dmenu installed. Run 'startx' to launch DWM."
