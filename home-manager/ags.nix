{ inputs, pkgs, ... }:
{
  # add the home manager module
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    # symlink to ~/.config/ags
    configDir = ./ags;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.system}.battery
      inputs.ags.packages.${pkgs.system}.network
      inputs.ags.packages.${pkgs.system}.bluetooth
      inputs.ags.packages.${pkgs.system}.tray
      inputs.ags.packages.${pkgs.system}.hyprland
      fzf
    ];
  };
}
