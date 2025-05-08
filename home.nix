{ pkgs, ... }:

{
  home = rec { 
    username="minearchive";
    homeDirectory = "/home/${username}"; # 文字列に値を埋め込む
    stateVersion = "24.11";
  };

  # home-manager enable
  programs.home-manager.enable = true;

  #####################################
  #           D E F A U L T           #
  #####################################

  home.file = {
    "wallpaper.jpg" = {
      target = "Wallpaper/wallpaper.jpg";
      source = builtins.toString ./wallpaper/wallpaper_atri.jpg;
    };
  };

  home.packages = with pkgs; [
    bat
    bottom
    httpie
    ripgrep
    ffmpeg
    tree
  ];

  imports = [
    ./home-manager/git.nix
    ./home-manager/development.nix
    ./home-manager/app.nix
    ./home-manager/hyprland.nix
  ];
}
