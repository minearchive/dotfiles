{ pkgs, ... }: {
  xdg.configFile = {
    "hypr/hyprland.conf" = {
      source = builtins.toString ./hypr/hyprland.conf;
    };

    "hypr/hyprpaper.conf" = {
      source = builtins.toString ./hypr/hyprpaper.conf;
    };
  };

  home.packages = with pkgs; [
    rofi
  ];
}
