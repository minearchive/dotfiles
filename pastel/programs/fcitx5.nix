{ ... }:
{
  programs.fcitx5 = {
    enable = true;
    settings = {
      config = {
        Behavior = {
          ShareInputState = "All";
        };
      };
    };
  };
}
