{ pkgs, inputs, ... }: {
  # Spotify TUI
  programs.ncspot.enable = true;

  # OBS
  programs.obs-studio.enable = true;

  home.packages = with pkgs; [
    discord
    spotify
    vscode
    obsidian

    tetrio-desktop

    vmware-horizon-client

    slurp
    grim
    swappy
    wl-clipboard
    unzip
  ];

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };
}
