{
  pkgs,inputs,
  ...
}:
let
  agents = inputs.llm-agents-nix.packages.x86_64-linux;
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
      agents.claude-code
    ];

  };

  imports = [
    ./programs/fish.nix
    ./programs/git.nix
  ];
}
