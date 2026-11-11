# The bar (github:minearchive/shell). niri starts it (`spawn-at-startup "my_shell"`), and
# matugen writes its colours to ~/.config/my_shell/theme.toml (matugen/config.nix).
{ inputs, pkgs, ... }:
let
  my-shell = inputs.my-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [ my-shell ];

  # Edited, it reloads on its own; theme.toml is matugen's.
  xdg.configFile."my_shell/animation.toml".source = "${inputs.my-shell}/example/animation.toml";
}
