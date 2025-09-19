{ pkgs, inputs, ... }: {
  imports = [
    ./rice.nix
    ./development.nix
    ./neovim.nix
  ];
}
