{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
    ./audio.nix
    ./msi-ec.nix
    ./power.nix
    ../shared/niri.nix
    ../shared/showjiwm.nix
    ../shared/configuration.nix
  ];

  networking.hostName = "msiLaptop";

  hardware.graphics.extraPackages = with pkgs; [
    vpl-gpu-rt
    intel-vaapi-driver
    intel-media-driver
  ];

  boot.kernelParams = [
    "i915.force_probe=a7aa"
    "snd-intel-psdcfg.dsp_driver=1"
  ];

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  services.thermald.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    proton-vpn
  ];
}
