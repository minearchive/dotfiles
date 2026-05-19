{
  pkgs,
  inputs,
  ...
}:

let
  hyprlandPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
in

{
  services.xserver.updateDbusEnvironment = true;

  services.gnome.gnome-keyring.enable = true;
  security = {
    polkit.enable = true;
    pam.services = {
      hyprlock = { };
      gdm.enableGnomeKeyring = true;
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XCURSOR_SIZE = "24";
  };

  programs.hyprland = {
    package = hyprlandPkg;
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hypridle
    hyprlock
    hyprpicker
    hyprsunset
  ];
}
