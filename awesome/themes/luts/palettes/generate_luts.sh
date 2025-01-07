#! /bin/bash
# in argument write one word - name of lut
# sh ~/.config/awesome/themes/luts/palettes/generate_lut.sh <lut_name>
ls *.txt

luts=($(ls *.txt 2>/dev/null | awk -F. '{print $1}'))

for lut in "${luts[@]}"
do
    $HOME/.config/awesome/other/bin/lutgen generate -o $HOME/.config/awesome/themes/luts/$lut.png -- $(cat $HOME/.config/awesome/themes/luts/palettes/$lut.txt)
done



