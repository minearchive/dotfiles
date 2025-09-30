{ pkgs, inputs, ... }: {
  # デスクトップカスタマイズ系設定のみ残す

  imports = [
    ./hypr/hypr.nix
  ];

  home.packages = with pkgs; [
    rofi
    zenity
  ];

  # notification daemon
  home.file.".config/mako/config".text = ''
    default-timeout=1
    background-color=#00000000
    text-color=#00000000
    border-size=0
    padding=0
    width=1
    height=1
  '';
}
