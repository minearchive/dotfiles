{ pkgs, ... }:
# let
#   logseq-patched = pkgs.logseq.override {
#     electron_27 = pkgs.electron_35;
#   };
# in
{

  imports = [
    ./development.nix
    ./quickshell.nix
    ./templates.nix
  ];

  home.packages = with pkgs; [

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
}
