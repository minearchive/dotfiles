#!/usr/bin/env bash

# Open zenity file selector for image files
FILE=$(zenity --file-selection --title="Select Wallpaper Image" --file-filter="Images | *.png *.jpg *.jpeg *.bmp *.webp *.gif *.mp4")

# Check if a file was selected
if [ -z "$FILE" ]; then
  echo "No file selected, exiting."
  exit 1
fi

matugen image "$FILE" -c ~/.config/matugen/config.toml

swww img "$FILE" --transition-type outer --transition-pos 0.857,0.977 --transition-step 90 --transition-fps 60

