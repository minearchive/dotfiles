{
  lib,
  ...
}:

{
  imports = [ ../shared/hyprland.nix ];

  # Reference: https://github.com/AlexNabokikh/nix-config/blob/b605b34bd672e36cb395e94213d6ed670bb63e5f/modules/nixos/desktop/hyprland/default.nix#L49

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.uwsm.waylandCompositors.hyprland = lib.mkForce {
    prettyName = "Hyprland-fix";
    comment = "Modern compositor with the looks";
    binPath = "/run/current-system/sw/bin/start-hyprland";
  };
}
