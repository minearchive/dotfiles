{ pkgs, ... }: {
  # デスクトップカスタマイズ系設定
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
  ];

  # カーソル設定
  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };

}
