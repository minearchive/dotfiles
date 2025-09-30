{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  quickshell = inputs.quickshell.packages.${pkgs.system}.default;
in
{
  # Idk i have no idea.
  home.activation.runqs = lib.mkAfter ''
    export PATH=${quickshell}/bin:${pkgs.gawk}/bin:$PATH:${pkgs.hyprland}/bin

    chmod -R u+w "$HOME/.local/share/qs-bar" 2>/dev/null || true
    kill $(quickshell list --all | grep Process | awk '{print $3}')
    rm -rf "$HOME/.local/share/qs-bar"
    mkdir -p "$HOME/.local/share/qs-bar"
    cp -ri ${./quickshell}/. "$HOME/.local/share/qs-bar"
    chmod -R u+w "$HOME/.local/share/qs-bar"
    hyprctl dispatch exec "quickshell -p ~/.local/share/qs-bar"
    echo "QuickShell files copied to ~/.local/share/qs-bar"
  '';

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    color_scheme_path=minearchive/.config/qt5ct/colors/matugen.conf
    custom_palette=true
  '';

  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @import 'colors.css';
  '';

  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @import 'colors.css';
  '';

  home.packages = [
    quickshell
    pkgs.libsForQt5.qt5ct
  ];
}
