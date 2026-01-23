{ pkgs, ... }:
{
  programs.gemini-cli = {
    enable = true;
  };

  programs.zed-editor = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  programs.wofi = {
    enable = true;
  };

  home.packages = with pkgs; [
    tree
    nixd
    nil
    bat
    jq
    ripgrep
    bottom
    vesktop
    slurp
    swappy
    devenv
    direnv
    yt-dlp
    ffmpeg-full
    figma-linux
  ];
}
