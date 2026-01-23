{ inputs, pkgs, ... }:
let
  quickshell = inputs.quickshell.packages.${pkgs.system}.default;
in
{
  home.packages = [
    quickshell
  ];
}
