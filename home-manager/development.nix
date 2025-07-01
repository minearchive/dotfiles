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
    deno

    devenv
    
    #IDE
    jetbrains.rust-rover
    jetbrains.idea-ultimate

    #Jetbrain plugins
    github-copilot-intellij-agent
  ];
}
