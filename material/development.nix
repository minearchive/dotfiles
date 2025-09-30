{
  pkgs,
  lib,
  inputs,
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
    #IDE
    jetbrains.rust-rover
    jetbrains.idea-ultimate
    #Jetbrain plugins
    github-copilot-intellij-agent

    nixd
    nil

    zed-editor
    figma-linux

    discord
    vscode
    vesktop
    obs-studio
    protonvpn-gui
    wireguard-tools
  ];

  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      include = "colors.conf";
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      allow_remote_control = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "0.8";
      background_blur = 10;
      symbol_map =
        let
          mappings = [
            "U+23FB-U+23FE"
            "U+2B58"
            "U+E200-U+E2A9"
            "U+E0A0-U+E0A3"
            "U+E0B0-U+E0BF"
            "U+E0C0-U+E0C8"
            "U+E0CC-U+E0CF"
            "U+E0D0-U+E0D2"
            "U+E0D4"
            "U+E700-U+E7C5"
            "U+F000-U+F2E0"
            "U+2665"
            "U+26A1"
            "U+F400-U+F4A8"
            "U+F67C"
            "U+E000-U+E00A"
            "U+F300-U+F313"
            "U+E5FA-U+E62B"
          ];
        in
        (builtins.concatStringsSep "," mappings) + " JetBrainsMono Nerd Font";
    };
  };

  programs.git = {
    enable = true;
    userName = "minearchive";
    userEmail = "102400088+minearchive@users.noreply.github.com";
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-markdown-preview ];
    settings = {
      editor = "nvim";
    };
  };

  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    plugins.lualine.enable = true;

    extraPlugins = [
      # pkgs.vimPlugins.quick-scope
    ];
  };

  # Theming of vscode
  home.file.".config/vscode.css".text = ''
    body {
      --radius: 8px;
    }
  '';
}
