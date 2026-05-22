{ pkgs, inputs, ... }:
let
  agents = inputs.llm-agents-nix.packages.x86_64-linux;
  kyoshin = inputs.kyoshin-flake.packages.x86_64-linux.default;
in
{
  programs.gemini-cli = {
    enable = true;
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.packages =
    with pkgs;
    [
      devenv
      direnv
      yt-dlp
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
    ]
    ++ [
      agents.antigravity
      agents.claude-code
      agents.opencode
      agents.codex
      kyoshin
    ];
}
