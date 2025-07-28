{ pkgs, ... }: {
  # 開発系設定のみ残す
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
    cmake
    devenv
    #IDE
    jetbrains.rust-rover
    jetbrains.idea-ultimate
    #Jetbrain plugins
    github-copilot-intellij-agent

    discord
    vscode
    vesktop
    obs-studio
  ];

  programs.git = {
    enable = true;
    userName = "minearchive";
    userEmail = "102400088+minearchive@users.noreply.github.com";
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    extensions = with pkgs; [gh-markdown-preview];
    settings = {
      editor = "nvim";
    };
  };
}
