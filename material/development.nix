{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gcc
    go
    nodePackages.pnpm
    deno
    python312
    jdk
    dart
    bun
    nodejs_22
    cmake
    devenv
    direnv
    #IDE
    jetbrains.rust-rover
    jetbrains.idea-ultimate
    #Jetbrain plugins
    github-copilot-intellij-agent

    nixd
    nil
    qt6.qtdeclarative

    # zed-editor
    figma-linux
  ];

  # Theming of vscode
  home.file.".config/vscode.css".text = ''
    body {
      --radius: 8px;
    }
  '';

  imports = [
    ./programs/firefox.nix
    ./programs/git.nix
    ./programs/hyprland.nix
    ./programs/kitty.nix
    ./programs/mako.nix
    ./programs/neovim.nix
    ./programs/zed.nix
    ./programs/spotify.nix
    ./programs/wlogout.nix
  ];
}
