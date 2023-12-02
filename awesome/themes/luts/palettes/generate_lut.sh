#! /bin/bash
# in argument write one word - name of lut
# sh ~/.config/awesome/themes/luts/palettes/generate_lut.sh <lut_name>
$HOME/.local/bin/lutgen generate -o $HOME/.config/awesome/themes/luts/$1.png -- $(cat $HOME/.config/awesome/themes/luts/palettes/$1.txt)