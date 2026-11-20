# Matugen テンプレートと Zed フォント周りのメモ

`pastel/programs/matugen/*.nix` と `pastel/programs/zed.nix` の
コメントを移したもの。設定値そのものより「なぜその値か」を残す。

## herdr (`matugen/herdr.nix`)

herdr は kitty の中に描画されるので、**kitty のパレットと色味を揃える**。
matugen が生成した M3 のロールをそのまま当てると kitty とズレる。

- `accent` / `panel_bg` など構造的なトークンは M3 ロール
  (`primary`, `background`) に追従させる。
- `red` / `green` / `yellow` / `blue` / `teal` / `mauve` は
  **固定色**。M3 には green/yellow/teal/peach に相当するロールが無いため
  (error は赤、tertiary は紫寄りになる)、hue を固定して
  kitty パレットの bright 系と同じ値にしている。
- `peach` はどちらのパレットにも対応する色が無いので未設定のまま。
  その場合 catppuccin の値が使われる。
- `[theme] name = "catppuccin"` は下のトークンが未設定だったときの
  土台になるベーステーマ。

壁紙に追従させたい場合は `red` などを M3 ロールへ差し替える:

```toml
red   = "{{colors.error.default.hex}}"
blue  = "{{colors.secondary.default.hex}}"
mauve = "{{colors.tertiary.default.hex}}"
```

## Zed の日本語フォールバック (`zed.nix`)

SOROEMONO は日本語のゴシック体で、**Bold がアウトライン (縁取り) デザイン**
になっている。これをそのまま Zed の日本語フォールバックに使うと、
Zed がフォールバック面を「プライマリフォントの weight」で照合するため、
Latin 側まで太い見た目になりがち。

対処として build 時に fonttools で名前テーブルを書き換え、
**別ファミリー "Zed Japanese Bold" として派生**させている:

- Bold のアウトラインフォントに `usWeightClass = 400` (Regular) を付与し、
  Latin は Regular のまま日本語だけ縁取りを維持できるようにする。
- 元の BoldItalic などは Bold ファミリー側 (`usWeightClass = 700`) に割り当てる。
- 上流ファミリーを直接改変せず別名にしているのは、他アプリで同じ
  SOROEMONO を普通に使えるようにするため。

`fonts.fontconfig.enable = true` は Zed にパッケージ済みフォントを
見つけさせるため。フォールバック順は Zed 側の設定で制御する。

`lsp.texlab.binary.path` は Nix の `pkgs.texlab` に固定している。
Zed 既定の自動ダウンロードを使わない。

## kitty (`matugen/kitty.nix`)

`color0`〜`color15` のブロックは matugen の出力ではなく、割り当ての
対応表の意味でコメント (`# black`, `# red` ...) が付いている。これは
可読性のためのもので消さない。

## fish の `tex` 関数

`latex.codecogs.com` に LaTeX を投げて PNG を受け取り `kitten icat` で
表示する関数。以前は背景を白で指定していたが、`\bg_transparent` に
戻して透過させている。`#set text(fill: white, size: 20pt)` は
いつでも戻せるようにコメントアウトで残してある。
