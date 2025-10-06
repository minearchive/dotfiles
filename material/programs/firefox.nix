{ ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      DisableAppUpdate = false;
    };
  };
}
