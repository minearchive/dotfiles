{ inputs, ... }:
{
  home.packages = [
    inputs.llm-agents-nix.packages.x86_64-linux.antigravity-cli
  ];
}
