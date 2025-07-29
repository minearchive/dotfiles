{ pkgs, ... }: {
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
    hyprlandPlugins.hyprgrass
  ];
}
