#!/bin/sh

cp -R awesome ~/.config/
cp -R alacritty ~/.config/
cp -R nvim ~/.config/
cp -R fontconfig ~/.config/
cp .xinitrc ~/

cd ~/.config/awesome/other/bin/ && wget https://github.com/erebe/greenclip/releases/download/v4.2/greenclip && chmod +x greenclip
cd ~/.config/awesome/other/bin/ && wget https://github.com/ozwaldorf/lutgen-rs/releases/download/v0.11.2/lutgen-0.11.2-x86_64.tar.gz && tar -xvzf lutgen-0.11.2-x86_64.tar.gz && rm LICENSE.md lutgen-0.11.2-x86_64.tar.gz && chmod +x lutgen
cd ~/.config/awesome/themes/luts/palettes/ && chmod +x generate_luts.sh && sh generate_luts.sh
