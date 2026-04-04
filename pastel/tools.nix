{ pkgs, inputs, ... }:
let
  antigravity = inputs.antigravity-nix.packages.x86_64-linux.default;
  claude = inputs.claude-code.packages.x86_64-linux.default;
  kyoshin = inputs.kyoshin-flake.packages.x86_64-linux.default;
in
{
  programs.gemini-cli = {
    enable = true;
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
      opencode
      prismlauncher
      cloudflared
      obsidian
      gimp
      inkscape
      slack
    ]
    ++ [
      antigravity
      claude
      kyoshin
    ];
}
