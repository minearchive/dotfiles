{
  config,
  pkgs,
  ...
}:

{
  # MSI Modern 14 H (MS-14L1, EC 14L1EMS1) のファン/電源プロファイル制御。
  # 標準の msi_wmi_platform は hwmon の fan*_input (RPM) しか出さないので、
  # 書き込み可能な EC インターフェースを出す msi-ec を使う。
  boot.extraModulePackages = [ config.boot.kernelPackages.msi-ec ];
  boot.kernelModules = [ "msi-ec" ];

  # 起動時の既定値を入れ、wheel から sudo 無しで書き換えられるようにする。
  #   shift_mode:   eco | comfort | sport | turbo
  #   fan_mode:     auto | silent | basic | advanced
  #   cooler_boost: 0 | 1
  services.udev.extraRules = ''
    SUBSYSTEM=="platform", KERNEL=="msi-ec", ATTR{shift_mode}="comfort", ATTR{fan_mode}="auto", RUN+="${pkgs.bash}/bin/bash -c 'chgrp wheel /sys/devices/platform/msi-ec/{shift_mode,fan_mode,cooler_boost}; chmod g+w /sys/devices/platform/msi-ec/{shift_mode,fan_mode,cooler_boost}'"
  '';
}
