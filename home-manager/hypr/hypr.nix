{ pkgs, ... }: {
  xdg.configFile = {
    "hypr/hyprland.conf" = {
      source = builtins.toString ./hyprland.conf;
    };

    "hypr/hyprpaper.conf" = {
      source = builtins.toString ./hyprpaper.conf;
    };

    "hypr/hyprland/animation.conf" = {
      source = builtins.toString ./hyprland/animation.conf
    };

    "hypr/hyprland/general.conf" = {
      source = builtins.toString ./hyprland/general.conf
    };

    "hypr/hyprland/keybind.conf" = {
      source = builtins.toString ./hyprland/keybind.conf
    };

    "hypr/hyprland/startup.conf" = {
      source = builtins.toString ./hyprland/startup.conf
    };
  };

  home.packages = with pkgs; [
    rofi
  ];
}
