{ inputs, pkgs, ... }:
let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [
    quickshell
    pkgs.qt6.qttools
    pkgs.qt6.qtdeclarative
  ];
}
