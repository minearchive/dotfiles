# バッテリー駆動時の消費電力削減 (MSI Modern 14 H)

## 結論

CPU 側の省電力は **power-profiles-daemon (PPD) が既に担当している**。
今回の変更で不足していたのは **MSI EC の制御** だけだった。

- AC 接続 → `shift_mode=comfort`, `super_battery=off`
- バッテリー → `shift_mode=eco`, `super_battery=on`

これを AC の抜き差し / 起動 / サスペンド復帰で自動適用する。
`hosts/msiLaptop/power.nix` を追加し、`hosts/msiLaptop/configuration.nix` から import。

## 調査で分かったこと (重要)

### 1. PPD は既に稼働していた

`/run/current-system` には `power-profiles-daemon` のバイナリが無いので
「未設定」だと誤認しやすいが、GNOME 経由 `power-profiles-daemon-0.30` が
systemd unit として有効になっている。

```sh
systemctl is-enabled power-profiles-daemon   # linked
systemctl is-active  power-profiles-daemon   # active
```

ドライバ構成は D-Bus から確認できる:

```sh
busctl call net.hadess.PowerProfiles /net/hadess/PowerProfiles \
  org.freedesktop.DBus.Properties Get ss net.hadess.PowerProfiles Profiles
```

結果:

| Profile | CpuDriver | PlatformDriver |
|---|---|---|
| power-saver | intel_pstate | placeholder |
| balanced | intel_pstate | placeholder |
| performance | intel_pstate | (なし) |

- `intel_pstate` ドライバは **EPP を AC / バッテリーで書き換える**
  (`ppd-driver-intel-pstate.c` の `power_changed` → `apply_pref_to_devices`)。
  balanced なら AC=`balance_performance`, バッテリー=`balance_power`。
- したがって **EPP を外から書いてはいけない**。PPD と相互に上書きし合う。
- `PlatformDriver` は `placeholder`。EC には何も伝わっていない。

### 2. ACPI platform_profile は存在しない

```sh
ls /sys/firmware/acpi/platform_profile   # 無い
cat /sys/devices/platform/msi-ec/available_shift_modes   # turbo eco comfort
```

`msi-ec` は `shift_mode` を公開するが `platform_profile` は公開しない。
PPD の platform-profile ドライバは `/sys/firmware/acpi/platform_profile` の
**存在**でプローブする (`ppd-driver-platform-profile.c` の
`ppd_driver_platform_profile_probe`) ので、この機種では動かない。

### 3. hwdb で PPD の書き込みをリダイレクトする方法は使えない

`/usr/lib/udev/README` などに書かれている
`platform:<name>:attr:<attr>=<val>` 形式は実装されていない。
実測では次の形だけがマッチした:

```sh
systemd-hwdb query 'platform:platform:platform_profile=low-power:'
# → platform:*: は不可。<attr>=<val> を 4 段目に置く形も不可
```

さらに systemd 262 のソースには platform サブシステム向けの
`platform_profile` 参照実装が無く、`PLATFORM_PROFILE_CHOICES` を
hwdb で与えても PPD は読まない (PPD は sysfs の
`platform_profile_choices` を読む)。
→ hwdb 方式は**機能する見込みが無い**ので採用しなかった。

## 実装

### `hosts/msiLaptop/power.nix`

- `msi-power-apply` スクリプト: AC 状態を読んで `shift_mode` /
  `super_battery` を書く (`charger` / `battery` / `restore`)。
- `msi-power-auto.service`: udev の `power_supply` change イベントから起動。
  AC ドライバ初期化途中にイベントが飛ぶことがあるので 2 秒待ってから読む。
- `msi-power-init.service`: 起動時に一度適用 (イベント取りこぼしの保険)。
- `msi-power-resume.service`: サスペンド復帰後に再適用。
- `msi-power` コマンド: 手動切替 (`sudo` 不要、wheel なら直接書ける)。
- カーネルパラメータ: `pcie_aspm.policy=powersupersave`,
  `usbcore.autosuspend=2`。
- `systemd.sleep.settings.Sleep.SuspendMode=s2idle` を明示。

### `hosts/msiLaptop/msi-ec.nix`

`super_battery` を wheel から書き込み可能にするよう udev ルールを拡張した
(これが無いと `msi-power` が `super_battery` を書けない)。

## 使い方

```sh
msi-power battery   # バッテリー運用の設定にする
msi-power charger   # AC 接続の設定に戻す
msi-power restore   # 現在の AC 状態に合わせる (既定)
```

AC の抜き差しで自動的に切り替わるので、通常は使わなくてよい。
`msi-power-apply` は `msi-ec` が無いカーネルでは何もせず終了する。
`shift_mode` / `super_battery` が書き込み不可でも落ちずに続行する。

## 検証方法

```sh
# 適用後、AC を抜いて数秒待つ
cat /sys/devices/platform/msi-ec/shift_mode      # eco
cat /sys/devices/platform/msi-ec/super_battery   # on
cat /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference  # power (PPD 経由)

# AC を挿す
cat /sys/devices/platform/msi-ec/shift_mode      # comfort
cat /sys/devices/platform/msi-ec/super_battery   # off

# 消費電力の比較 (バッテリー駆動で数分置いてから)
upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep energy-rate
```

ログ: `journalctl -u msi-power-auto -u msi-power-init -u msi-power-resume`

## 注意点

- `nixos-rebuild switch` が必要 (カーネルパラメータと udev ルールのため)。
  再起動は不要だが、`pcie_aspm` と `usbcore.autosuspend` を効かせるには
  **再起動が要る**。
- `pcie_aspm.policy=powersupersave` で NVMe/WiFi が不安定になる場合は
  `powersave` に落とす。
- `shift_mode` / `super_battery` の sysfs への実書き込みは
  sudo が使えない環境では検証できなかった (見た目の権限と実際の可否が
  一致しない環境だった)。適用後に上記のコマンドで確認すること。

## 参考: バッテリーの劣化

```
energy-full:         37.1868 Wh
energy-full-design:  52.44 Wh
capacity:            70.913%
```

容量が設計値の約 71% まで落ちている。バッテリー自体の劣化が
「持ちが悪い」体感の主因である可能性が高い。設定で取り戻せる分は限定的。
