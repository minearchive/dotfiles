{pkgs, ...}: {
  home.packages = with pkgs; [
    gcc
    go
    nodejs-slim
    nodePackages.pnpm
    deno
    bun
    python312
    jdk
    dart
  ];
}
