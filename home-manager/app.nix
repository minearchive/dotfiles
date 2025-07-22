{ pkgs, inputs, ... }: {
  # Spotify TUI
  # OBS
  # デスクトップカスタマイズ系はrice.nixへ移動
  imports = [
    ./rice.nix
    ./development.nix
  ];
}
