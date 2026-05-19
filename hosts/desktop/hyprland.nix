{
  pkgs,
  ...
}:

let
  hypr-plugin-dir = pkgs.symlinkJoin {
    name = "hyrpland-plugins";
    paths = [
      # hyprexpo
      #...plugins
    ];
  };
in

{
  imports = [ ../shared/hyprland.nix ];

  environment.sessionVariables = {
    HYPR_PLUGIN_DIR = hypr-plugin-dir;
  };

  programs.hyprland.withUWSM = true;
}
