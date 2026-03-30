{ pkgs, inputs, ... }:
# let
#   logseq-patched = pkgs.logseq.override {
#     electron_27 = pkgs.electron_35;
#   };
# in
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

      swappy
      slurp

      discord
      vscode
      vesktop
      obs-studio
      protonvpn-gui
      wireguard-tools

      # logseq-patched
      logseq
      fastfetch

      cmatrix
      cava

      manix

      nwg-displays
      qdirstat
      opencode
    ];
  };

  wayland.windowManager.hyprland.settings = {
    device = [
      {
        name = "-------vspo!-keyboard";
        kb_layout = "jp";
        repeat_delay = 400;
        repeat_rate = 60;
      }
      {
        name = "-------vspo!-keyboard-consumer-control";
        kb_layout = "jp";
      }
      {
        name = "-------vspo!-keyboard-system-control";
        kb_layout = "jp";
      }
      {
        name = "-------vspo!-keyboard-1";
        kb_layout = "jp";
      }
    ];
  };

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };

  xdg.configFile = {
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-cursor-theme-name=phinger-cursors-light
    '';
  };

  imports = [
    ./development.nix
    ./quickshell.nix
    ./templates.nix
    inputs.spicetify-nix.homeManagerModules.default
  ];
}
