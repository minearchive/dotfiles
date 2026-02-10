{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
    ../shared/configuration.nix
  ];

  nix.settings = {
    download-buffer-size = 21474836480;
  };

  networking.hostName = "desktop";

  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  hardware.graphics = {
    enable = true;
  };

  boot.kernelModules = [ "nvidia-uvm" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    winetricks
    wineWowPackages.waylandFull
    wineWowPackages.stagingFull

    libvpx
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    wireguard-tools
    protonvpn-gui
  ];

  networking.firewall.checkReversePath = false;

  services.samba.enable = true;
}
