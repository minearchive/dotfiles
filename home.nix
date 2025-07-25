{ config, pkgs, inputs, ... }:

{
  home = rec { 
    username="minearchive";
    homeDirectory = "/home/${username}"; # 文字列に値を埋め込む
    stateVersion = "25.05";
  };

  # home-manager enable
  programs.home-manager.enable = true;
  
  home.file = {
    "wallpaper.jpg" = {
      target = "Wallpaper/wallpaper.jpg";
      source = builtins.toString ./home-manager/wallpaper/wallpaper_atri.jpg;
    };
  };

  home.packages = with pkgs; [
    bat
    bottom
    httpie
    ripgrep
    ffmpeg
    tree
    jq
  ];

  imports = [
    ./home-manager/development.nix
    ./home-manager/app.nix
    ./home-manager/hyprland.nix
    ./home-manager/quickshell.nix

    inputs.spicetify-nix.homeManagerModules.default
  ];
}
