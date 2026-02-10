{ pkgs, inputs, ... }:
let
  antigravity = inputs.antigravity-nix.packages.x86_64-linux.default;
in
{
  programs.gemini-cli = {
    enable = true;
  };

  home.packages = [
    antigravity
    pkgs.devenv
    pkgs.direnv
    pkgs.yt-dlp
    pkgs.ffmpeg-full
    pkgs.figma-linux
    pkgs.nodejs_22
    pkgs.nodePackages.pnpm
    pkgs.deno
    pkgs.bun
    pkgs.jetbrains.idea
    pkgs.vscode
    pkgs.pipes-rs
    pkgs.clock-rs
    pkgs.cmatrix
    pkgs.cava
    pkgs.opencode
    pkgs.prismlauncher
    pkgs.cloudflared
    pkgs.obsidian
  ];
}
