{ pkgs, inputs, ... }:
let
  agents = inputs.llm-agents-nix.packages.x86_64-linux;
  kyoshin = inputs.kyoshin-flake.packages.x86_64-linux.default;
  apple-music = inputs.sidra.packages.x86_64-linux.default;
  herdr = inputs.herdr.packages.x86_64-linux.default;
  yt-dlp-package = inputs.nixpkgs-yt-dlp.legacyPackages.${pkgs.stdenv.hostPlatform.system}.yt-dlp;
  label-studio-cli = pkgs.writeShellScriptBin "label-studio" ''
    export LD_LIBRARY_PATH="${
      pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.zlib
      ]
    }''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    exec ${pkgs.uv}/bin/uv tool run --python ${pkgs.python312}/bin/python3 --from label-studio==1.23.2 label-studio "$@"
  '';
  # ponytail: dependencies need network on first run; package in Nix if offline reproducibility is needed.
  colab-cli =
    (pkgs.writeShellScriptBin "colab" ''
      export LD_LIBRARY_PATH="${
        pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]
      }''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      exec ${pkgs.uv}/bin/uv tool run --python ${pkgs.python312}/bin/python3 --from google-colab-cli==0.7.4 colab "$@"
    '').overrideAttrs
      (old: {
        buildCommand = old.buildCommand + ''
          ln -s colab "$out/bin/colab-cli"
        '';
      });
in
{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.packages =
    with pkgs;
    [
      devenv
      direnv
      yt-dlp-package
      ffmpeg-full
      figma-linux
      nodejs_22
      pnpm
      deno
      bun
      jetbrains.idea
      vscode
      pipes-rs
      clock-rs
      cmatrix
      cava
      cbonsai
      tenki
      prismlauncher
      steamcmd
      cloudflared
      obsidian
      gimp
      inkscape
      slack
      fastfetch
      evince
      wl-clipboard
      hyprshot
      lollypop
      puddletag
      recoll
      unzip
      playerctl
      chromium
      obs-studio
      kdePackages.kdenlive
      alacritty
      typst
      tinymist
      wl-mirror
      brightnessctl
      pandoc
      poppler-utils
      claude-agent-acp
      bitwig-studio
      xwayland
      xwayland-satellite
      krita
    ]
    ++ [
      agents.antigravity-cli
      agents.claude-code
      agents.ccusage
      agents.opencode2
      agents.codex
      agents.omp
      agents.chatgpt
      agents.claude-desktop
      # See notes/dsh-require-builtin-patch.md
      agents.dsh
      herdr
      colab-cli
      label-studio-cli
      kyoshin
      apple-music
    ];
}
