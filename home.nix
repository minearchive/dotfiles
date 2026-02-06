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

  wayland.windowManager.hyprland.settings = {
    device = [
      {
        name = "-------vspo!-keyboard";
        kb_layout = "jp";
        repeat_delay = 400;
        repeat_rate = 60;
      },
      {
        name = "-------vspo!-keyboard-consumer-control";
        kb_layout = "jp";
      },
      {
        name = "-------vspo!-keyboard-system-control";
        kb_layout = "jp";
      },
      {
        name = "-------vspo!-keyboard-1";
        kb_layout = "jp";
      }
    ];
  };

  imports = [
    ./material/material.nix
    inputs.spicetify-nix.homeManagerModules.default
  ];
}
