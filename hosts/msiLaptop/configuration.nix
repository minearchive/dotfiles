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
    ../shared/niri.nix
    ../shared/showjiwm.nix
    ../shared/configuration.nix
  ];

  # MSI Laptop specific hardware configuration

  networking.hostName = "msiLaptop";

  # Intel GPU drivers for MSI Laptop
  hardware.graphics.extraPackages = with pkgs; [
    vpl-gpu-rt
    intel-vaapi-driver
    intel-media-driver
  ];

  # Kernel parameters for MSI Laptop hardware
  boot.kernelParams = [
    "i915.force_probe=a7aa"
    "snd-intel-psdcfg.dsp_driver=1"
  ];

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Keep the firmware-controlled fan curve, while letting thermald reduce CPU
  # power before the package reaches its 100 C critical temperature.
  services.thermald.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    proton-vpn
  ];
}
