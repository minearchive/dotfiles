{
  pkgs,
  inputs,
  ...
}:

{
  programs.home-manager.enable = true;

  home = rec {
    username = "minearchive";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    packages = with pkgs; [
      bat
      bottom
      httpie
      ripgrep
      tree
      jq
    ];
  };

  imports = [
    ./material/material.nix
    inputs.spicetify-nix.homeManagerModules.default
  ];
}
