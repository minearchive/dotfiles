{ pkgs, inputs, ... }: let

in {

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    plugins.lualine.enable = true;

    extraPlugins = [
      pkgs.vimPlugins.quick-scope
    ];
  };
}
