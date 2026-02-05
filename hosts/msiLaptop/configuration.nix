{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/configuration.nix
  ];

  # MSI Laptop specific hardware configuration

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
}
