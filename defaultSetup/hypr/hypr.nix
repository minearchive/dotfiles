{ pkgs, ... }: {
  xdg.configFile = {
    "hypr/hyprland.conf" = {
      source = builtins.toString ./hyprland.conf;
    };

    "hypr/hyprpaper.conf" = {
      source = builtins.toString ./hyprpaper.conf;
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

    "hypr/script/workspace_jump.sh" = {
      source = builtins.toString ./script/workspace_jump.sh;
    };

    "hypr/script/move_window_to_ws.sh" = {
      source = builtins.toString ./script/move_window_to_ws.sh;
    };

    "hypr/script/wallpaper_change.sh" = {
      source = builtins.toString ./script/wallpaper_change.sh;
    };

    "hypr/script/floating.sh" = {
      source = builtins.toString ./script/floating.sh;
    };
  };

  home.packages = with pkgs; [
    rofi
  ];
}
