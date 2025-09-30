{ pkgs, ... }: {
  xdg.configFile = {
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-cursor-theme-name=phinger-cursors-light
    '';
  };

  imports = [
    ./hyprland.nix
    ./quickshell.nix
    ./development.nix
    ./quickshell.nix
  ];

  home.packages = with pkgs; [
    grim
    swappy
    slurp

    tetrio-desktop

    cmatrix
    cava
  ];

  # カーソル設定
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
