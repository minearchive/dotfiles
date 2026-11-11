{ pkgs, user, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.email = user.email;
      user.name = user.name;
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
