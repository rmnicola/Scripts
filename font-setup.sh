#!/usr/bin/bash

declare font_dir=$HOME/.local/share/fonts

echo ">> Creating local font dir."
mkdir -vp $font_dir

echo ">> Downloading Fonts."
curl -Lo Hack.zip --output-dir $font_dir \
  "https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip"

echo ">> Unziping Fonts."
unzip $font_dir/Hack.zip -d $font_dir/Hack
echo ">> Cleaning Up."
rm $font_dir/Hack.zip

echo ">> Rebuilding font cache."
fc-cache -f

