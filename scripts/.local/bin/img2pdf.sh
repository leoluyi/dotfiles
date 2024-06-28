#!/usr/bin/env bash

if ! command -v convert &>/dev/null; then
  echo -e 'Command `convert` not found.\nPlease install "Imagemagic" by `brew install imagemagick`'
  exit 1
fi

img_files=$(find . -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' \))
echo -e "Find files:\n${img_files}"

# Move original files to tempdir.
tempdir=$(mktemp -d)
echo "Tempdir: ${tempdir}"
echo "$img_files" | xargs -d"\n" -P0 -I_ cp "_" -t "$tempdir"
img_files=$(find "$tempdir" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' \) | sort -n)

# https://askubuntu.com/a/987341
echo
echo "1. Detecting min width among images..."
min_width=$(echo "$img_files" | xargs -P0 -I_ identify -format '%w\n' "_" | sort -n | head -1)

if [ "$min_width" -gt 1280 ]; then
  echo "(Original min_width ${min_width}px is too big. Use 1280px instead.)"
  min_width=1280
else
  echo "(Use min_width: ${min_width}px)"
fi
# https://stackoverflow.com/a/28937338/3744499
echo
echo "2. Remove alpha channel in images and resize..."
echo "$img_files" | xargs -d"\n" -P0 -I_ convert "_" -resize "${min_width}x" -background white -alpha remove -alpha off "_"

echo
echo "3. Combining images to 'output.pdf'"
old_ifs="$IFS"
IFS=$'\n'
convert -quality 40 $(echo "$img_files") ouput.pdf
IFS="$old_ifs"
