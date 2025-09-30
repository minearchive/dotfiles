{ config, pkgs, inputs, ... }:

{
  home = rec { 
    username="minearchive";
    homeDirectory = "/home/${username}"; # 文字列に値を埋め込む
    stateVersion = "25.05";
  };
  
  # home-manager enable
  programs.home-manager.enable = true;

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
    ./material/material.nix
    inputs.spicetify-nix.homeManagerModules.default
  ];
}
