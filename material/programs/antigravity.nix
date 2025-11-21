{ inputs, ... }:
let
  antigravity = inputs.antigravity-nix.packages.x86_64-linux.default;
in
{
  home.packages = [
    antigravity
  ];
}
