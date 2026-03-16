{
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;
let
  hyprlandPkg = inputs.hyprland.packages.${pkgs.system}.hyprland;
  hyprPluginPkgs = inputs.hyprland-plugins.packages.${pkgs.system};
  hypr-plugin-dir = pkgs.symlinkJoin {
    name = "hyrpland-plugins";
    paths = with hyprPluginPkgs; [
      # hyprexpo
      #...plugins
    ];
  };
in

{
  # Call dbus-update-activation-environment on login
  services.xserver.updateDbusEnvironment = true;

  # Enable security services
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services = {
    hyprlock = { };
    gdm.enableGnomeKeyring = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XCURSOR_SIZE = "24";
    HYPR_PLUGIN_DIR = hypr-plugin-dir;
  };

  programs.hyprland = {
    package = hyprlandPkg; # fuck nix pkgs
    enable = true;
    xwayland.enable = true;
    withUWSM = true; # recommended for most users
  };

  environment.systemPackages = with pkgs; [
    hypridle
    hyprlock
    hyprpicker
    hyprsunset
  ];
}
