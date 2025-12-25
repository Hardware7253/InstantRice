#!/bin/bash
clear
read -n 1 -s -r -p "This script will overide most of your existing configs for any relevant programs, thus is only recommended for fresh systems (press any key to continue)"
initpath=$PWD
clear

# Copy configs
cp config/.Xresources ~
cp config/.xinitrc ~
cp config/.xbindkeysrc ~
cp -r config/.vim ~
cp config/.vimrc ~
cp config/kitty.conf ~/.config/kitty/
chmod +x ~/.xinitrc

append() {
	grep -qF -- "$append_line" "$append_file" || echo "$append_line" >> "$append_file"
}

# Double font sizes and dpi if the user has a high dpi screen
read -r -n 1 -p "$*Setup for high dpi screen? [y/N]: " yn
yn=${yn:-N}
case $yn in
	[Yy]*)
		sed -i 's/96/192/g' ~/.Xresources
		sed -i 's/18/36/g' dmenu.h dwm.h dwmblocks.h  
	;;
	[Nn]*) ;;
esac
clear



# Path for suclkess and aur programs
src_path="/usr/src"

echo "Installing dwm, dmenu, and dwmblocks"
sudo pacman -S git xorg-xinit xorg xorg-server autorandr libx11 libxinerama libxft webkit2gtk base-devel ttf-jetbrains-mono
sudo chown $(whoami) /usr/src

# For building programs with make
build() {
	program_path="$src_path/$program"
	cd "$program_path"
	sudo make clean install
	return
}

# For installing aur packages
install() {
	program_path="$src_path/$program"
	cd "$program_path"
	makepkg -si PKGBUILD
	return
}

# For copying the configs to the source directory
copy_config() {
 cd "$initpath/config"
 cp "${program}.h" "$src_path/$program/config.h"
}

cd $src_path
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/dmenu
git clone https://github.com/torrinfail/dwmblocks.git

program="dwm"
copy_config
build

program="dmenu"
copy_config
build

program="dwmblocks"
copy_config
mv "$src_path/$program/config.h" "$src_path/$program/blocks.h"
build

clear



echo "Installing pywal"
cd ~
sudo pacman -S python-pywal xwallpaper acpi
mkdir -p Pictures/Wallpapers
cd Pictures/Wallpapers

git clone https://github.com/Hardware7253/changebg-wal.git
cp "changebg-wal/"* .
rm -rf changebg-wal
chmod +x changebg.sh
./changebg.sh

clear



cd ~
echo "Installing kitty"
sudo pacman -S kitty
mkdir .config
mkdir .config/kitty
append_file=".config/kitty/kitty.conf"
touch $append_file
append_line="include ~/.cache/wal/colors-kitty.conf
confirm_os_window_close 0
font_size 14.0"
append
clear



echo "Installing and configuring xbindkeys"
sudo pacman -S xbindkeys
cd $src_path
git clone https://aur.archlinux.org/brillo.git
program="brillo"
install
sudo chown $(whoami) /sys/class/backlight
clear



echo "Installing pcmanfm and udiskie"
sudo pacman -S pcmanfm udiskie xdg-utils ntfs-3g gvfs-mtp zip unzip xarchiver
xdg-mime default pcmanfm.desktop inode/directory application
clear



echo "Installing theming applications and themes"
sudo pacman -S lxappearance qt5ct breeze-gtk papirus-icon-theme

sudo chmod -R o+rwx /etc/environment
echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment

cd $src_path
git clone https://aur.archlinux.org/papirus-folders.git
program="papirus-folders"
install
clear



echo "Installing pulseaudio and pavucontrol"
sudo pacman -S pulseaudio pulseaudio-jack pulseaudio-alsa pavucontrol pamixer
pulseaudio -D
clear



echo "Installing SDDM"
sudo pacman -S sddm qt5-graphicaleffects qt5-svg qt5-quickcontrols2
sudo systemctl enable sddm.service

# Add dwm as session
sudo ln -s ~/.xinitrc /usr/bin/rundwm
sudo chmod +x /usr/bin/rundwm
sudo mkdir /usr/share/xsessions
echo "[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Log in using the Dynamic Window Manager
Exec=/usr/bin/rundwm
Icon=/usr/local/bin/dwm.png
Type=XSession" | sudo tee -a /usr/share/xsessions/dwm.desktop > /dev/null


# Install sddm theme
cd ~
mkdir temp
cd temp
git clone https://github.com/catppuccin/sddm.git
sudo cp -r sddm/src/catppuccin-mocha /usr/share/sddm/themes/
echo "[Theme]
Current=catppuccin-mocha" | sudo tee -a /etc/sddm.conf > /dev/null
cd ~
rm -rf temp
clear



echo "Installing media and misc programs"
sudo pacman -S noto-fonts-cjk neofetch htop flameshot gvim vi vimiv mpv figlet polkit-gnome

mkdir ~/Pictures/Screenshots

cd $src_path
git clone https://aur.archlinux.org/python-pysdl2.git
git clone https://aur.archlinux.org/tauon-music-box.git
git clone https://aur.archlinux.org/brave-bin.git 

program="python-pysdl2"
install

program="tauon-music-box"
install

program="brave-bin"
install

clear



figlet Install Complete
echo "Themes can be set in lxappearance and qt5ct"
echo "A system restart is recommended"
echo
read -n 1 -s -r -p "Press any key to continue"
clear
