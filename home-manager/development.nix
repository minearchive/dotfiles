{pkgs, ...}: {
  home.packages = with pkgs; [
    gcc
    go
    nodePackages.pnpm
    deno
    bun
    python312
    jdk
    dart
    nodejs_22
    
    devenv
    
    #IDE
    jetbrains.rust-rover
  ];
}
