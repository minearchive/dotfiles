{ ... }:
{
  xdg.configFile = {
    "hypr/hyprland.conf" = {
      source = builtins.toString ./hyprland.conf;
    };

    "hypr/hyprland/animation.conf" = {
      source = builtins.toString ./hyprland/animation.conf;
    };

    "hypr/hyprland/general.conf" = {
      source = builtins.toString ./hyprland/general.conf;
    };

    "hypr/hyprland/keybind.conf" = {
      source = builtins.toString ./hyprland/keybind.conf;
    };

    "hypr/hyprland/startup.conf" = {
      source = builtins.toString ./hyprland/startup.conf;
    };

    "hypr/hyprland/rule.conf" = {
      source = builtins.toString ./hyprland/rule.conf;
    };

    "hypr/hyprland/plugins.conf" = {
      source = builtins.toString ./hyprland/plugins.conf;
    };

    "hypr/script/move_window_to_ws.sh" = {
      text = ''
        if [ $2 == "0" ]; then
          hyprctl dispatch movetoworkspacesilent $1
        else
          hyprctl dispatch movetoworkspace $1
        fi
      '';
    };

    "hypr/script/wallpaper_change.sh" = {
      text = ''
        #!/usr/bin/env bash

        # Open zenity file selector for image files
        FILE=$(zenity --file-selection --title="Choose wallpaper" --file-filter="Images | *.png *.jpg *.jpeg *.bmp *.webp *.gif *.mp4")

        # Check if a file was selected
        if [ -z "$FILE" ]; then
          echo "No file selected, exiting."
          exit 1
        fi

        # Check if MATUGEN_SCHEME is set, otherwise default to dark

        if [ -z "$MATUGEN_SCHEME" ]; then
          MATUGEN_SCHEME="dark"
        fi

        echo "Using color scheme: $MATUGEN_SCHEME"

        matugen image "$FILE" -c ~/.config/matugen/config.toml --mode "$MATUGEN_SCHEME"

        swww img "$FILE" --transition-type outer --transition-pos 0.857,0.977 --transition-step 90 --transition-fps 60

        echo "$FILE" > ~/.config/wallpaper.info
      '';
    };
  };
}
