#!/bin/bash
clear



initpath=$PWD

## Copy Xresources into home folder
read -r -n 1 -p "$*Setup for high dpi screen? [y/N]: " yn
clear
yn=${yn:-N}
case $yn in
	[Yy]*) cp Xresources_hdpi Xresources ;;
	[Nn]*) ;;
esac
cp Xresources ~/.Xresources

## Path for suclkess and aur programs
srcpath="/usr/src"



echo "Installing dwm, dmenu, st, and dwmblocks"
read -p "Enter user: " user
sudo pacman -S git xorg-xinit xorg xorg-server libx11 libxinerama libxft webkit2gtk base-devel ttf-jetbrains-mono
sudo chown $user /usr/src

cd ~
rm .xinitrc
touch .xinitrc

cd $srcpath
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/dmenu
git clone https://git.suckless.org/st
git clone https://github.com/torrinfail/dwmblocks.git

## For installing suckless programs + dwmblocks
build() {
	programpath="$srcpath/$program"
	cd "$programpath"
	sudo make clean install
	return
}

## For installing aur packages
install() {
	programpath="$srcpath/$program"
	cd "$programpath"
	makepkg -si PKGBUILD
	return
}

program="dwm"
build

program="dmenu"
build

program="st"
build

program="dwmblocks"
build


cd ~
echo "dwmblocks &" >> .xinitrc
clear



echo "Installing pywal and updating configs"
cd ~
echo "[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources" >> .xinitrc
sudo pacman -S python-pywal xwallpaper acpi
mkdir -p Pictures/Wallpapers
cd Pictures/Wallpapers

git clone https://github.com/Hardware7253/changebg-wal.git
cp "changebg-wal/"* .
rm -rf changebg-wal
chmod +x changebg.sh
./changebg.sh

cd $srcpath
rm -rf suckless-configs
git clone https://github.com/Hardware7253/suckless-configs
cd suckless-configs
chmod +x update_configs.sh
./update_configs.sh
clear



echo "Installing and configuring xbindkeys"
cd $srcpath
git clone https://aur.archlinux.org/brillo.git
program="brillo"
install

cd ~
sudo pacman -S xbindkeys
git clone https://github.com/Hardware7253/xbindkeys-config.git
cd xbindkeys-config
chmod +x update_config.sh
./update_config.sh
cd ~
rm -rf xbindkeys-config
echo "xbindkeys" >> .xinitrc

sudo chown $user /sys/class/backlight

clear



echo "Installing pcmanfm and udiskie"
sudo pacman -S pcmanfm udiskie xdg-utils ntfs-3g gvfs-mtp xarchiver
echo "udiskie &" >> .xinitrc
xdg-mime default pcmanfm.desktop inode/directory application
clear



echo "Installing theming applications"
sudo pacman -S lxappearance qt5ct

sudo chmod -R o+rwx /etc/environment
echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment

cd $srcpath
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



echo "Installing media and misc programs"
sudo pacman -S flameshot vimiv mpv firefox figlet polkit-gnome

mkdir ~/Pictures/Screenshots

cd $srcpath
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

cd ~
echo "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &" >> .xinitrc
clear



## Make sure exec dwm is the last thing added to .xinitrc
cd ~
echo "exec dwm" >> .xinitrc
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
