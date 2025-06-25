{ config, pkgs, inputs, ... }:

{
  home = rec { 
    username="minearchive";
    homeDirectory = "/home/${username}"; # 文字列に値を埋め込む
    stateVersion = "24.11";
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
    # quickshell
  ];

  programs.ags.enable = true;

  imports = [
    ./home-manager/git.nix
    ./home-manager/development.nix
    ./home-manager/app.nix
    ./home-manager/hyprland.nix
    ./home-manager/ags.nix

    inputs.spicetify-nix.homeManagerModules.default
  ];
}
