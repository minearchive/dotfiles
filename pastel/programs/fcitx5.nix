{ ... }:
{
  # Single supervised fcitx5 instance; restarted automatically if it dies.
  # The binary comes from the system i18n.inputMethod (fcitx5-with-addons).
  systemd.user.services.fcitx5 = {
    Unit = {
      Description = "Fcitx 5 input method";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "/run/current-system/sw/bin/fcitx5 --replace";
      Restart = "always";
      RestartSec = 1;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Hide the system XDG autostart entry so it doesn't race the service above.
  xdg.configFile."autostart/org.fcitx.Fcitx5.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
