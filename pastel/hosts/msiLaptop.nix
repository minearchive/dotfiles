{ pkgs, inputs, ... }:
{
  home.packages =
    with pkgs;
    [
      # msiLaptop-specific packages
    ]
    ++ [
      inputs.hermes-agent.packages.x86_64-linux.desktop
    ];
}
