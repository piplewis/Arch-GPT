# Arch-GPT
Updating my Arch install script after 4 years with the help of ChatGPT

# My Arch Install Script (UK Based) - Work in Progress  

A simple installation script to automate an **Arch Linux** and **DWM** installation with **UK keyboard/language settings** and the apps I use.  

This script helps me avoid forgetting key installation steps.  

---

## **💻 Installation Process**
### **1️⃣ Boot into Arch Installation Media**
- Start your system from an **Arch ISO (USB/DVD)**.
- Open a terminal.

### **2️⃣ Prepare the System**
- **Set UK keyboard layout**:
  ```bash
  loadkeys uk

    Partition the drive (Modify as needed):
        Example for UEFI:

    mkfs.ext4 /dev/sda2

    Modify based on your setup.

Ensure Wi-Fi is working (for laptops):

rfkill unblock all
iwctl
station wlan0 connect "your-wifi-name"
password > "your-password"

Update package lists:

pacman -Syy

Install git (needed to clone this repo):

    pacman -S --noconfirm git

3️⃣ Install the Base System

mount /dev/sda2 /mnt
pacstrap /mnt base linux-lts linux-lts-headers vim
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

📥 Clone My Arch Install Scripts
4️⃣ Clone This Repo

git clone https://github.com/piplewis/arch-setup
cd arch-setup

5️⃣ Modify for Your Username & Bootloader

Before running the script, update the username from piplewis to your own:

    Open install_arch.sh:

nano install_arch.sh

Change:

    useradd -m piplewis
    echo "piplewis:changeme" | chpasswd
    echo "piplewis ALL=(ALL) ALL" > /etc/sudoers.d/piplewis

    to use your username.

    Modify Bootloader Section (BIOS/UEFI)
        The script defaults to UEFI.
        If using BIOS, uncomment the grub-install --target=i386-pc line and change /dev/sda.

⚙ Run the Arch Installation Script
6️⃣ Run the Main Script

chmod +x install_arch.sh install_dwm.sh
./install_arch.sh

    Installs essential packages, GPU drivers, PipeWire, security tools, etc.
    Sets up Networking, Bootloader (GRUB), and System Services.
    Creates a new user.

7️⃣ Reboot

reboot

    Log in as the new user.

🖥️ Install DWM, st, and dmenu
8️⃣ Run the DWM Installation Script

sudo ./install_dwm.sh

    Installs dwm, st (simple terminal), and dmenu from source.
    Sets up .xinitrc to launch DWM.

9️⃣ Start DWM

startx

    Enjoy your minimal, fast, and UK-configured Arch setup.

🔗 Credits

    Inspired by Doc10's script and modified to fit my needs:
    https://github.com/document10/scriptsrep
    Fixed line ending issues (no need for dos2unix anymore 🎉).

✅ Summary

    Scripts automate Arch installation for a UK-based system with DWM.
    Supports UEFI & BIOS (modify install_arch.sh).
    Includes GPU autodetection, PipeWire sound, and essential tools.
    DWM, st, and dmenu are installed via a separate script.

"Reboot and Bob's your uncle!" 😆
