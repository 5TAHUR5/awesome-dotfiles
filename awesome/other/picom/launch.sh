#!/bin/bash

pkill picom
while pgrep -u $UID -x picom >/dev/null; do sleep 1; done

case $1 in
--opacity)
	picom --config $HOME/.config/awesome/other/picom/picom.conf -b &
	;;
--no-opacity)
	picom --config $HOME/.config/awesome/other/picom/picom_no_opacity.conf -b &
	;;
esac
