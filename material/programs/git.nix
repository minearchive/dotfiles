{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.email = "102400088+minearchive@users.noreply.github.com";
      user.name = "minearchive";
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-markdown-preview ];
    settings = {
      editor = "nvim";
    };
  };
}
