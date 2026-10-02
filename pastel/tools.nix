{ pkgs, inputs, ... }:
let
  agents = inputs.llm-agents-nix.packages.x86_64-linux;
  kyoshin = inputs.kyoshin-flake.packages.x86_64-linux.default;
  apple-music = inputs.sidra.packages.x86_64-linux.default;
  herdr = inputs.herdr.packages.x86_64-linux.default;
  yt-dlp-package = inputs.nixpkgs-yt-dlp.legacyPackages.${pkgs.stdenv.hostPlatform.system}.yt-dlp;
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
      alacritty
      typst
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
      herdr
      kyoshin
      apple-music
    ];
}
