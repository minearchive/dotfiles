{ config, lib, pkgs, inputs, ... }:

let
  quickshell = inputs.quickshell.packages.${pkgs.system}.default;
in
{
  imports = [
    inputs.matugen.nixosModules.default
  ];

  xdg.configFile."matugen/config.toml".source = builtins.toString ./template/config.toml;
  xdg.configFile."qt5ct/qt5ct.conf".source = builtins.toString ./template/qtct.conf;

  home.activation.copyfile = lib.mkAfter ''
    echo "Copying matugen templates..."
    rm -rf "$HOME/.local/share/matugen/template"
    mkdir -p "$HOME/.local/share/matugen/template"
    cp -r ${./template/templates}/. "$HOME/.local/share/matugen/template"
    echo "Matugen templates copied."
  '';

  home.activation.runqs = lib.mkAfter ''
    chmod -R u+w "$HOME/.local/share/qs-bar"
    rm -rf "$HOME/.local/share/qs-bar"
    mkdir -p "$HOME/.local/share/qs-bar"
    cp  -ri ${./quickshell}/. "$HOME/.local/share/qs-bar"
    chmod -R u+w "$HOME/.local/share/qs-bar"
  '';

  home.packages = [
    quickshell
    pkgs.libsForQt5.qt5ct
  ];
}