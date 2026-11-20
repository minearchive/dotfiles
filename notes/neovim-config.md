# neovim (nixvim) 構成メモ

`pastel/programs/neovim.nix` は nixvim 経由で設定している。コード側の
コメントを削ってここに理由を残す。

## 前提・外部依存

- **asm-lsp** はアセンブラ/コンパイラを PATH から呼んで診断するので、
  `extraPackages` に `gcc` と `nasm` を入れている。
- **presence.nvim** は unfree。`allowUnfreePredicate` で名前を限定して許可する。
  経緯は `notes/nixvim-unfree-plugins.md`。
- **ripgrep** は `home.packages` (Nix) から供給される。telescope の
  `live_grep` はそれを使う。
- **rust-analyzer** も Nix が供給する。rustaceanvim の `server.cmd` を
  ストアパスに固定し、mason.nvim / PATH に依存させていない。

## 設計上の判断

### Flutter と dartls

`flutter-tools` が dartls を所有する。**`plugins.lsp.servers.dartls` を
併せて有効にしてはいけない** (二重起動になる)。

- `:FlutterRun` で起動、Dart ファイルの保存でフォーマット後にホットリロード。
- `:FlutterRestart` は full hot restart が必要なとき。
- `:FlutterQuit` で停止。

`flutter-tools.package` は `pkgs.vimPlugins.flutter-tools-nvim` を
明示している。nixvim の既定より新しいプラグインで、`FlutterQuit` 時の
nil-output クラッシュが直っているため。

### leader

`mapleader` はスペース。`<leader>w` 系のウィンドウ移動フォールバックを
押しやすくするため。

### ウインドウ/ターミナル

- `splitbelow` / `splitright` は toggleterm を水平に開き、新しい分割が
  下/右に出る前提に合わせている。
- toggleterm は画面下の水平分割 (`direction = "horizontal"`, `size = 15`)。
- `<C-\>` で n / t 両モードから開閉。t モードの `<Esc>` は
  `<C-\><C-n>` に割り当てて insert から抜ける。

### Rust (rustaceanvim)

- `cargo.allFeatures` と `buildScripts.enable`、`procMacro.enable` を有効。
- `checkOnSave` で保存時に cargo check を回してリアルタイム診断。
  clippy を入れるなら `check.command = "clippy"` に変える。
- `lens.enable` でコードレンズ (Run | Debug | references / implementations)。
- inlay hints は複数種類を有効にしているが、**エディタ側のトグルは
  `LspAttach` autocmd で行う** (下記)。

### inlay hints / code lens

`LspAttach` autocmd で、LSP が `inlayHintProvider` / `codeLensProvider` を
持つ場合にバッファ単位で有効化する。`vim.lsp.codelens.enable` が無い
(Nvim 0.10 未満相当の) 場合は `refresh()` にフォールバックする。

### フォーマット

conform.nvim で保存時フォーマット。

- Rust: `rustfmt`
- Dart: Flutter 同梱の Dart SDK (`pkgs.flutter/bin/dart`) を
  `dart_format` のコマンドに指定

`timeout_ms = 500`、LSP フォールバックあり。

### キーマップ一覧

| キー | 動作 |
|---|---|
| `<A-CR>` | code action (n/v) |
| `<C-\>` | toggleterm 開閉 (n/t) |
| `<Esc>` | ターミナルから insert を抜ける (t) |
| `<C-Tab>` / `<C-S-Tab>` | 次/前のバッファ |
| `<S-l>` / `<S-h>` | 次/前のバッファ (ターミナルが `<C-Tab>` を食う場合のフォールバック) |
| `<leader>c` | バッファを閉じる |
| `<C-f>` | バッファ内ファジー検索 |
| `<C-S-f>` | 全ファイル grep |
| `<leader>ff` | ファイル検索 |
| `<leader>fb` | バッファ一覧 |

### その他

- `plugins.crates` で Cargo.toml の依存管理。
- `plugins.bufferline` でバッファをタブ表示、neo-tree のオフセットを設定。
- completion は cmp + LSP / luasnip / buffer / path。
