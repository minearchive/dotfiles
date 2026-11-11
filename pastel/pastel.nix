{ pkgs, user, ... }:
{
  programs.home-manager.enable = true;

  home = rec {
    username = user.name;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";

    packages = with pkgs; [
      bat
      bottom
      httpie
      ripgrep
      rust-analyzer
      rustfmt
      tree
      jq
      firefox
      nixd
      nil
      wofi
      swappy
      slurp

      python312
      python312Packages.pip
      python312Packages.virtualenv
      p7zip
      uv
    ];

    pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;

      gtk.enable = true;
      x11.enable = true;
    };
  };

  imports = [
    ./programs/fcitx5.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/hyprland.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/niri.nix
    ./programs/shojiwm.nix
    ./programs/pi.nix
    ./programs/zen.nix
    ./programs/discord.nix
    ./programs/zed.nix
    ./programs/spotify.nix
    ./programs/quickshell.nix
    ./programs/my-shell.nix
    ./programs/wlogout.nix
    ./programs/matugen.nix
    ./tools.nix
  ];

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
}
