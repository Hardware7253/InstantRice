dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
dwmblocks &
[[ -f ~/.Xresources ]] && xrdb -merge -I/home/oxnh ~/.Xresources
xbindkeys
autorandr -c
udiskie &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
xwallpaper --center ~/Picutres/Wallpapers/Leaves.jpg
exec dwm
