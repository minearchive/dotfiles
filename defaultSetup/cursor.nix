{ pkgs, ... }: {
  # デスクトップカスタマイズ系設定のみ残す
  xdg.configFile = {
    "gtk-3.0/settings.ini" = {
      source = builtins.toString ./cursor.ini;
    };
  };
}
