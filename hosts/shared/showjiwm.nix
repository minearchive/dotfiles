{ inputs, user, ... }:
{
  imports = [
    inputs.shojiwm.nixosModules.default
  ];

  programs.shojiwm = {
    enable = true;

    portal.enable = true;

    initConfig = {
      enable = true;
      users = [ user.name ];
    };
  };
}
