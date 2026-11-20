# MSI Modern 14 H (MSI Laptop) 固有の設定メモ

`hosts/msiLaptop/` 配下の設定値の理由をまとめる。

## GPU / カーネルパラメータ

- `hardware.graphics.extraPackages` に `vpl-gpu-rt`, `intel-vaapi-driver`,
  `intel-media-driver`。Intel GPU で VA-API / QSV のハードウェアデコードを
  使うため。`intel-vaapi-driver` は旧世代向け、`intel-media-driver` は
  Gen 以降向けで両方入れておく。
- `i915.force_probe=a7aa`
  該当する Intel グラフィックスは、このカーネルでまだ
  probe 対象外 (もしくは probe 順の都合で拾われない)。デバイス ID を
  明示して probe させる。
- `snd-intel-psdcfg.dsp_driver=1`
  サウンドの DSP ドライバ選択。既定の挙動で音が出ないため、
  `dsp_driver=1` (SOF ではなく legacy HDA) を指定している。

## thermald

`services.thermald.enable = true` にしてある。ファンカーブはファームウェア
側に任せたまま、パッケージ温度が 100 ℃ の臨界点に達する前に
thermald が CPU 電力を下げる。ファン制御に踏み込ませない。

## msi-ec

`hosts/msiLaptop/msi-ec.nix` を参照。`msi_wmi_platform` は hwmon の
`fan*_input` (RPM) しか公開しないので、書き込み可能な EC インターフェースを
出す `msi-ec` を使っている。`shift_mode` / `fan_mode` / `cooler_boost` /
`super_battery` は wheel から書き換えられるよう udev で権限を付けている。

省略可能な値の一覧:

- `shift_mode`: `eco` | `comfort` | `sport` | `turbo`
- `fan_mode`: `auto` | `silent` | `basic` | `advanced`
- `cooler_boost`: `0` | `1`
- `super_battery`: `on` | `off`

## 電源まわり

`hosts/msiLaptop/power.nix` が AC 状態に応じて `shift_mode` と
`super_battery` を切り替える。詳細は `notes/battery-power-savings.md`。

## KDE Connect

`programs.kdeconnect` は GNOME 環境なので `gnomeExtensions.gsconnect` を
パッケージに指定している。

## オーディオ

`hosts/msiLaptop/audio.nix` は Yamaha DM3 を 96 kHz / Pro Audio
プロファイル固定で使うための設定。`session.suspend-timeout-seconds = 0`
でアイドル時サスペンドを止めている。
