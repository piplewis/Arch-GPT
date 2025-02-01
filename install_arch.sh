#!/bin/bash

set -e  # Exit on any error

# Set timezone
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Set locale
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "KEYMAP=uk" > /etc/vconsole.conf

# Configure hostname and network
echo "arch" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain arch
EOF

# Set root password (Change this manually)
echo "root:changeme" | chpasswd

# Update mirrors first
echo "Updating mirrors..."
pacman -S --noconfirm reflector
reflector -c "GB" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Update system and install core packages
pacman -Syu --noconfirm
pacman -S --noconfirm linux-lts linux-lts-headers linux-firmware intel-ucode amd-ucode \
grub efibootmgr os-prober sudo vim base-devel xdg-user-dirs xdg-utils terminus-font \
openssh bash-completion networkmanager dnsutils ufw firewalld htop btop fzf xclip \
pipewire pipewire-alsa pipewire-jack wireplumber

# GPU Drivers (Auto-detect)
if lspci | grep -i "NVIDIA"; then
    pacman -S --noconfirm nvidia nvidia-lts nvidia-utils nvidia-settings nvidia-prime nvtop
elif lspci | grep -i "AMD"; then
    pacman -S --noconfirm xf86-video-amdgpu mesa vulkan-radeon nvtop
elif lspci | grep -i "Intel"; then
    pacman -S --noconfirm mesa xf86-video-intel vulkan-intel
fi

# Xorg (Required for dwm)
pacman -S --noconfirm xorg xorg-server xorg-xinit

# Bootloader setup
if [ -d /sys/firmware/efi ]; then
    [ ! -d /boot/efi ] && mkdir /boot/efi
    mount /dev/sda1 /boot/efi
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
else
    grub-install --target=i386-pc /dev/sda  # Modify manually if needed
fi
grub-mkconfig -o /boot/grub/grub.cfg

# Final configuration
mkinitcpio -P

# Enable essential services
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable ufw.service
systemctl enable firewalld

# Create a new user
useradd -m piplewis
echo "piplewis:changeme" | chpasswd
echo "piplewis ALL=(ALL) ALL" > /etc/sudoers.d/piplewis

# Ensure the scripts are executable
chmod +x install_dwm.sh

echo "Installation complete. Reboot and then run the DWM setup script."
