{
  pkgs,inputs,
  ...
}:
let
  claude = inputs.claude-code.packages.x86_64-linux.default;
in
{
  home = rec {
    username = "MineArchive";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    packages = with pkgs; [
      git
      github-cli
      direnv
      nil
      nixd
    ] ++ [
      claude
    ];

  };

  imports = [
    ./programs/fish.nix
    ./programs/git.nix
  ];
}
