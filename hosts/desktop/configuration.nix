{
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
    ../shared/configuration.nix
  ];

  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
  };

  hardware.graphics = {
    enable = true;
  };

  boot.kernelModules = [ "nvidia-uvm" ];

  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
}
