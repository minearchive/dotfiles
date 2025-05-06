{pkgs, ...}: {
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
