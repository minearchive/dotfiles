{ pkgs, ... }:
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
      zed-editor
      firefox
      nixd
      nil
      wofi
      vesktop
      swappy
      slurp

      python312
      python312Packages.pip
      python312Packages.virtualenv
      p7zip
    ];

    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;

      gtk.enable = true;
      x11.enable = true;
    };
  };

  imports = [
    ./programs/fish.nix
    ./programs/hyprland.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/zen.nix
    ./programs/spotify.nix
    ./programs/quickshell.nix
    ./programs/wlogout.nix
    ./programs/matugen.nix
    ./tools.nix
  ];

  gtk.cursorTheme = "phinger-cursors-light";
}
