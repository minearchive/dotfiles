{ pkgs, ... }:
# let
#   logseq-patched = pkgs.logseq.override {
#     electron_27 = pkgs.electron_35;
#   };
# in
{
  xdg.configFile = {
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-cursor-theme-name=phinger-cursors-light
    '';
  };

  imports = [
    ./hyprland.nix
    ./development.nix
    ./quickshell.nix
    ./templates.nix
  ];

  home.packages = with pkgs; [
    grim
    swappy
    slurp

    tetrio-desktop

    # logseq-patched
    logseq

    cmatrix
    cava
  ];

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };

  programs.firefox = {
    enable = true;
    policies = {
      DisableAppUpdate = false;
    };
  };
}
