{ pkgs, ... }: {
  imports = [
    ./cursor.nix
    ./hyprland.nix
    ./quickshell.nix
  ];

  # import pkgs
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
    profiles = {
      default = {
        userChrome = builtins.readFile ./firefox/userChrome.css;
      };
    };
  };
}
