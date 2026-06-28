{ inputs, ... }:
{
  imports = [
    inputs.shojiwm.nixosModules.default
  ];

  programs.shojiwm = {
    enable = true;

    portal.enable = true;

    xwaylandSatellite.enable = true;

    initConfig = {
      enable = true;
      users = [ "minearchive" ];
    };
  };
}
