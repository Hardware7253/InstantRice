#!/bin/bash
clear



## Path for suclkess and aur programs
srcpath="/usr/src"



echo "Installing dwm, dmenu, st, and dwmblocks"
read -p "Enter user: " user
sudo pacman -S git xorg-xinit xorg xorg-server libx11 libxinerama libxft webkit2gtk base-devel ttf-ubuntu-font-family
sudo chown $user /usr/src

cd ~
touch .xinitrc
echo "exec dwm" > .xinitrc

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
echo "dwmblocks &" | cat - .xinitrc > temp && mv temp .xinitrc
clear



echo "Installing pywal and updating configs"
cd ~
sudo pacman -S python-pywal xwallpaper acpi
mkdir -p Pictures/Wallpapers
cd Pictures/Wallpapers

git clone https://github.com/Hardware7253/changebg-wal.git
cp "changebg-wal/"* .
rm -rf changebg-wal
chmod +x changebg.sh
./changebg.sh

cd $srcpath
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
echo 'xbindkeys' | cat - .xinitrc > temp && mv temp .xinitrc
clear



echo "Installing pcmanfm and udiskie"
sudo pacman -S pcmanfm udiskie xdg-utils
echo 'udiskie &' | cat - .xinitrc > temp && mv temp .xinitrc
xdg-mime default pcmanfm.desktop inode/directory application
clear



echo "Installing theming applications"
sudo pacman -S lxappearance qt5ct

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
clear



echo "Installing media and misc programs"
sudo pacman -S flameshot deepin-image-viewer celluloid firefox

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
clear
