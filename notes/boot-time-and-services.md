# 起動時間短縮と常駐プロセスの削減 (hosts/shared/configuration.nix)

起動を遅らせていたサービスを止めた記録。設定値そのものより、
**なぜ止めたか / 何秒節約したか** を残す。

計測は `systemd-analyze blame` と `systemd-analyze critical-chain` による。

## ブートローダ

- `boot.loader.timeout = 1`
  systemd-boot のメニュー待ちが 5 秒で、起動時に避けられる最大の遅延だった。
  世代選択のためにキー入力の余地として 1 秒は残す。
- `boot.loader.systemd-boot.configurationLimit = 3`
  ESP の空きが約 209MB、1 世代が約 58MB なので 3 世代に制限している。

## 無効化した起動サービス

| 対象 | 理由 | 効果 |
|---|---|---|
| `systemd-binfmt` | AppImage の binfmt を切ったのでハンドラが不要 | `binfmt_misc` のマウント待ち約 0.9 秒 |
| `NetworkManager-wait-online` | 起動時に回線待ちをする必要が無い | 約 5.4 秒 |
| `waydroid-container` | Android セッションを使うときだけ必要 | 約 0.4 秒 |
| `clamav-freshclam.timer` | CLI と設定は残し、定期更新だけ止める | — |
| `docker` (システム全体デーモン) | 使っていない。rootless Docker のみ使う | network-online 依存が外れる |
| `programs.appimage.binfmt` | 登録は毎回起動時に約 0.9 秒かかる | AppImage は `appimage-run` で実行する |
| `opentabletdriver` (user unit) | ドライバは入れっぱなしにするが必要時のみ起動 | ログイン時の常駐を回避 |

`systemd-binfmt` を止めているので、AppImage を直接実行しても動かない。
`appimage-run ./Foo.AppImage` を使う。必要になったら手動で
`sudo systemctl start systemd-binfmt` すれば一時的に有効にできる。

OpenTabletDriver は必要なときに:

```sh
systemctl --user start opentabletdriver
```

## 常駐プロセスの削減 (CPU 消費)

- `services.avahi.enable = false`
  GNOME が既定で有効にするが、コアの約 21% を消費していた。
- `services.printing.enable = false`
  プリンタを設定していないので CUPS ごと無効化。
- `services.clamav.daemon.enable = false`
  `clamscan` と freshclam の設定は残し、不定期な手動スキャンに使う。
- `networking.modemmanager.enable = false`
  WWAN モデムを積んでいない。
- `services.hardware.bolt.enable = false`
  Thunderbolt デバイスを使っていない。
- `services.tailscale.enable = false`, `services.openssh.enable = false`
  使っていない。ただし sops が SSH ホスト鍵を復号に使うので
  `openssh.generateHostKeys = true` は残す (sshd は起動しない)。

## 関連

- バッテリー駆動時の消費電力削減は `notes/battery-power-savings.md`。
- Fontconfig 2.17 互換の経緯は `notes/nixos-home-manager.md`。
- WARP の `nft` パス問題は `notes/nixos-home-manager.md`。
- sops / hermes-agent の運用も `notes/nixos-home-manager.md`。
