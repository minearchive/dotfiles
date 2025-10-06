{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
    plugins.neo-tree.enable = true;
    plugins.web-devicons.enable = true;
    plugins.mini.enable = true;

    extraPlugins = [
      # pkgs.vimPlugins.quick-scope
    ];
  };
}
