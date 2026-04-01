{
  ...
}:

{
  imports = [
    ../shared/configuration.nix
  ];

  nix.settings = {
    download-buffer-size = 21474836480;
  };

  networking.hostName = "wsl";
}
