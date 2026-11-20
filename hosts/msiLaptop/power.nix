{ pkgs, ... }:

let
  acOnline = pkgs.writeShellScript "msi-power-ac-online" ''
    for ac in /sys/class/power_supply/ADP* /sys/class/power_supply/AC*; do
      [ -r "$ac/online" ] && { cat "$ac/online"; exit 0; }
    done
    echo 0
  '';

  applyMode = pkgs.writeShellScript "msi-power-apply" ''
    set -eu
    ec=/sys/devices/platform/msi-ec

    if [ ! -d "$ec" ]; then
      echo "msi-power: msi-ec not found" >&2
      exit 0
    fi

    case "''${1:-restore}" in
      charger) online=1 ;;
      battery) online=0 ;;
      restore) online=$(${acOnline}) ;;
      *) echo "usage: $0 charger|battery|restore" >&2; exit 2 ;;
    esac

    if [ "$online" = "1" ]; then
      shift_mode=comfort
      super_battery=off
    else
      shift_mode=eco
      super_battery=on
    fi

    if [ -w "$ec/shift_mode" ]; then
      echo "$shift_mode" > "$ec/shift_mode" || true
    fi
    if [ -w "$ec/super_battery" ]; then
      echo "$super_battery" > "$ec/super_battery" || true
    fi

    echo "msi-power: online=$online shift_mode=$shift_mode super_battery=$super_battery"
  '';
in
{
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", \
      TAG+="systemd", ENV{SYSTEMD_WANTS}+="msi-power-auto.service"
  '';

  systemd.services."msi-power-auto" = {
    description = "Apply MSI EC power settings for the current AC state";
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
      ExecStart = "${applyMode} restore";
    };
  };

  systemd.services."msi-power-init" = {
    description = "Initial MSI EC power settings";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${applyMode} restore";
    };
  };

  systemd.services."msi-power-resume" = {
    description = "Re-apply MSI EC power settings after resume";
    after = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${applyMode} restore";
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "msi-power" ''
      exec ${applyMode} "''${1:-restore}"
    '')
    pkgs.powertop
    pkgs.upower
  ];

  boot.kernelParams = [
    "pcie_aspm.policy=powersupersave"
    "usbcore.autosuspend=2"
  ];

  systemd.sleep.settings.Sleep = {
    SuspendMode = "s2idle";
  };
}
