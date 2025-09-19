#!/usr/bin/env bash

# Open zenity file selector for image files
FILE=$(zenity --file-selection --title="Choose wallpaper" --file-filter="Images | *.png *.jpg *.jpeg *.bmp *.webp *.gif *.mp4")

# Check if a file was selected
if [ -z "$FILE" ]; then
  echo "No file selected, exiting."
  exit 1
fi

scheme="${MATUGEN_SCHEME:-dark}"
echo "Using color scheme: $scheme"

matugen image "$FILE" -c ~/.config/matugen/config.toml --mode "$scheme" 

swww img "$FILE" --transition-type outer --transition-pos 0.857,0.977 --transition-step 90 --transition-fps 60

