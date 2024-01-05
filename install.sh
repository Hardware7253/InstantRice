#!/bin/bash
clear
read -n 1 -s -r -p "This script will overide most of your existing configs for any relevant programs, thus is only recommended for fresh systems (press any key to continue)"
initpath=$PWD
clear

## Copy configs
cp config/.Xresources ~
cp config/.xinitrc_def ~
cp config/.xbindkeysrc ~
chmod +x ~/.xinitrc_def

append() {
	grep -qF -- "$append_line" "$append_file" || echo "$append_line" >> "$append_file"
}

cd ~
touch .xinitrc
append_file=".xinitrc"
append_line="xwallpaper --center ~/Pictures/Wallpapers/Leaves.jpg"
append
append_line="./.xinitrc_def ## Exit point, no exec before here"
append


## Double font sizes and dpi if the user has a high dpi screen
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



## Path for suclkess and aur programs
src_path="/usr/src"

echo "Installing dwm, dmenu, and dwmblocks"
sudo pacman -S git xorg-xinit xorg xorg-server autorandr libx11 libxinerama libxft webkit2gtk base-devel ttf-jetbrains-mono
sudo chown $(whoami) /usr/src

## For building programs with make
build() {
	program_path="$src_path/$program"
	cd "$program_path"
	sudo make clean install
	return
}

## For installing aur packages
install() {
	program_path="$src_path/$program"
	cd "$program_path"
	makepkg -si PKGBUILD
	return
}

## For copying the configs to the source directory
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
append_file=".config/kitty/kitty.conf"
touch $append_file
append_line="include ~/.cache/wal/colors-kitty.conf
font_size 14.0"
append
clear



echo "Installing and configuring xbindkeys"
cd $src_path
git clone https://aur.archlinux.org/brillo.git
program="brillo"
install
sudo chown $(whoami) /sys/class/backlight
clear



echo "Installing pcmanfm and udiskie"
sudo pacman -S pcmanfm udiskie xdg-utils ntfs-3g gvfs-mtp xarchiver
xdg-mime default pcmanfm.desktop inode/directory application
clear



echo "Installing theming applications"
sudo pacman -S lxappearance qt5ct

sudo chmod -R o+rwx /etc/environment
echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment

cd $src_path
git clone https://aur.archlinux.org/themix-gui-git.git
git clone https://aur.archlinux.org/themix-icons-papirus-git.git
git clone https://aur.archlinux.org/themix-theme-oomox-git.git

program="themix-gui-git"
install

program="themix-icons-papirus-git"
install

program="themix-theme-oomox-git"
install
clear



echo "Installing pulseaudio and pavucontrol"
sudo pacman -S pulseaudio pulseaudio-jack pulseaudio-alsa pavucontrol pamixer
pulseaudio -D
clear



echo "Installing SDDM"
sudo pacman -S sddm qt5-graphicaleffects qt5-svg qt5-quickcontrols2
sudo systemctl enable sddm.service

## Add dwm as session
sudo ln -s ~/.xinitrc /usr/bin/rundwm
sudo chmod +x /usr/bin/rundwm
echo "[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Log in using the Dynamic Window Manager
Exec=/usr/bin/rundwm
Icon=/usr/local/bin/dwm.png
Type=XSession" | sudo tee -a /usr/share/xsessions/dwm.desktop > /dev/null


## Install theme
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
sudo pacman -S flameshot vimiv mpv firefox figlet polkit-gnome

mkdir ~/Pictures/Screenshots

cd $src_path
git clone https://aur.archlinux.org/python-isounidecode.git
git clone https://aur.archlinux.org/python-pysdl2.git
git clone https://aur.archlinux.org/tauon-music-box.git
git clone https://aur.archlinux.org/python-pywalfox.git

program="python-isounidecode"
install

program="python-pysdl2"
install

program="tauon-music-box"
install

program="python-pywalfox"
install

clear



figlet Install Complete
echo "For theming:"
echo "Export theme and icons in themix-gui for gtk and qt themes"
echo "Afterwards themes can be set in lxappearance and qt5ct"
echo
echo "A system restart is also recommended"
echo
read -n 1 -s -r -p "Press any key to continue"
clear
