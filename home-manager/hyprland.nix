{ pkgs, ... }: {

  imports = [
    ./hypr/hypr.nix
  ];

  home.packages = with pkgs; [
    rofi
  ];
}
