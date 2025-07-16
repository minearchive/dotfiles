#!/usr/bin/env bash

# Open zenity file selector for image files
FILE=$(zenity --file-selection --title="Select Wallpaper Image" --file-filter="Images | *.png *.jpg *.jpeg *.bmp *.webp")

# Check if a file was selected
if [ -z "$FILE" ]; then
  echo "No file selected, exiting."
  exit 1
fi

extract_material_color "$FILE" "/home/minearchive/.theme/palette.qml"

# Get all monitor names from hyprctl
MONITORS=$(hyprctl monitors | grep "Monitor " | awk '{print $2}')

# set the selected wallpaper on all monitors
for MON in $MONITORS; do
  hyprctl hyprpaper preload "$FILE"
  hyprctl hyprpaper wallpaper "$MON,$FILE"
done

