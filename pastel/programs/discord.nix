{ inputs, ... }:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  programs.nixcord = {
    enable = true;
    discord.enable = false;
    equibop.enable = true;

    config = {
      frameless = true;
      plugins = {
        messageLogger.enable = true;
        translate.enable = true;
        showHiddenChannels.enable = true;
        clearUrls.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
