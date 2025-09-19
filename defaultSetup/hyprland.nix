{ pkgs, inputs, ... }: {
  # デスクトップカスタマイズ系設定のみ残す
  xdg.configFile = {
    "wallpaper.jpg" = {
      source = builtins.toString ./wallpaper/wallpaper_atri.jpg;
    };
  };

  imports = [
    ./hypr/hypr.nix
  ];

  home.packages = with pkgs; [
    rofi
    zenity
  ];

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   systemd.enable = false; # we use UWSM instead
  #   plugins = [
  #     pkgs.hyprlandPlugins.hyprexpo
  #     inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
  #   ];
  # };
}
