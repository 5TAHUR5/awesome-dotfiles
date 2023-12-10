#! /bin/bash

feh --no-fehbg --bg-fill $HOME/.config/awesome/themes/wall.jpg &
pgrep -x polkit-gnome-au > /dev/null || /usr/libexec/polkit-gnome-authentication-agent-1 &
pgrep -x $HOME/.config/awesome/other/bin/greenclip > /dev/null || $HOME/.config/awesome/other/bin/greenclip daemon &
#pgrep -x nm-applet > /dev/null || nm-applet --indicator 
