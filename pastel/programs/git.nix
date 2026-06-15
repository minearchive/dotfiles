{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.email = "102400088+minearchive@users.noreply.github.com";
      user.name = "minearchive";
      init.defaultBranch = "main";
    };
    hooks.pre-commit = pkgs.writeShellScript "pre-commit" ''
      staged=$(git diff --cached --name-only --diff-filter=ACM | grep '\.nix$' || true)
      [ -z "$staged" ] && exit 0
      ${pkgs.nixfmt-rfc-style}/bin/nixfmt $staged
      git add $staged
    '';
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-markdown-preview ];
    settings = {
      editor = "nvim";
    };
    gitCredentialHelper.enable = true;
  };
}
