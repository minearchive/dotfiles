{ pkgs, ... }:
{
  xdg.configFile."shojiwm/src" = {
    source = ./shojiwm;
    recursive = true;
    force = true;
  };

  xdg.configFile."shojiwm/wallpaper_change.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      FILE=$(zenity --file-selection --title="Choose wallpaper" --file-filter="Images | *.png *.jpg *.jpeg *.bmp *.webp *.gif *.mp4")
      if [ -z "$FILE" ]; then
        exit 1
      fi
      matugen image "$FILE" -c ~/.config/matugen/config.toml --mode "''${MATUGEN_SCHEME:-dark}" --source-color-index 0
      swww img "$FILE" --transition-type outer --transition-pos 0.857,0.977 --transition-step 90 --transition-fps 60
      echo "$FILE" > ~/.config/wallpaper.info
    '';
  };

  home.packages = with pkgs; [
    rofi
    zenity
    grim
    slurp
    hyprpicker
    brightnessctl
  ];
}
