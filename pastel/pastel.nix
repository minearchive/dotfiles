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
    ];
  };

  imports = [
    ./programs/hyprland.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/zen.nix
    ./tools.nix
  ];

  xdg.configFile = {
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-cursor-theme-name=phinger-cursors-light
    '';
  };
}
