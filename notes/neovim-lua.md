# Neovim: Lua 版と ASM 対応

## Lua 版

`pastel/programs/neovim/init.lua` は `pastel/programs/neovim.nix` の独立した Lua 版。
既存の Home Manager / Nixvim 設定は置き換えない。
Neovim **0.12 以上**と Git が必要。標準の `vim.pack` で初回起動時にプラグインを取得する。

通常の Neovim で、リポジトリのルートから実行する:

```sh
NVIM_APPNAME=pastel-lua nvim -u "$PWD/pastel/programs/neovim/init.lua"
```

現在の Nixvim ラッパーは既存プラグインを起動前に読み込むため、Lua 版の確認には
Nixvim ではない Neovim を使う。NixOS で通常版を一時的に使う例:

```sh
NVIM_APPNAME=pastel-lua nix run nixpkgs#neovim -- -u "$PWD/pastel/programs/neovim/init.lua"
```

常用する場合は `init.lua` を通常版 Neovim の設定ディレクトリに配置する。
`vim.pack` が同ディレクトリに生成する `nvim-pack-lock.json` も保存すると、
別環境でも同じプラグインリビジョンを利用できる。
更新は `:lua vim.pack.update()`。

Nix ストアの絶対パスは使わない。利用する言語に合わせて、次を PATH に用意する:

- `rg`: Telescope のプロジェクト内検索。
- `clangd`: C / C++。
- `tinymist`: Typst。
- `rust-analyzer`、`cargo`、`rustfmt`: Rust。
- Flutter SDK の `flutter` と `dart`: Dart LSP、実行、保存時整形。
- `asm-lsp`、`gcc`、`nasm`: ASM。下記参照。

Java は現在の nvim-java が JDTLS / JDK / Lombok / テスト・デバッグ用ツールを取得する。
NixOS ではダウンロードした JDK をそのまま実行できない場合があるため、
その場合は `require("java").setup()` の `jdk` に Nix で導入した JDK のルートを
`{ auto_install = false, path = "/path/to/jdk" }` として指定する。
Spring Boot Tools は元の設定どおり無効。
`mini.nvim` も元の設定どおり、個別モジュールは有効にしていない。

## Ubuntu: sudo なしで導入

Ubuntu x86_64 向けの `install-neovim-ubuntu.sh` を用意した。
`curl` / `tar` / `bzip2` / `sha256sum` と外部へのネットワーク接続が必要。
リポジトリのルートで実行する:

```sh
sh install-neovim-ubuntu.sh
~/.local/bin/pnvim
```

Neovim 0.12.6 は `~/.local/opt/nvim-0.12.6`、Git / ripgrep / asm-lsp / GCC /
NASM / unzip は micromamba で `~/.local/share/nvim-tools` に導入する。
Lua 設定は通常 `~/.config/pastel-lua/init.lua` に配置する（`XDG_CONFIG_HOME` の指定にも対応）。
既存の `~/.config/nvim` やシェル設定は変更しない。
再実行時はツール環境を再利用し、既存の Lua 設定・`pnvim` は番号付きでバックアップする。
Rust / Flutter / Typst などの SDK・LSP は別途必要。

### scp で Ubuntu のホーム以下に転送

転送元で、このリポジトリのルートから実行する。
`USER@HOST` は接続先のユーザー名・ホスト名に置き換える:

```sh
ssh USER@HOST 'mkdir -p "$HOME/nvim-setup"'
scp install-neovim-ubuntu.sh pastel/programs/neovim/init.lua USER@HOST:~/nvim-setup/
ssh -t USER@HOST 'sh "$HOME/nvim-setup/install-neovim-ubuntu.sh"'
```

スクリプトと `init.lua` の2ファイルだけでよく、リポジトリ全体の転送は不要。
導入後、Ubuntu 側で `~/.local/bin/pnvim main.s` などで起動する。
短く `pnvim` で呼びたい場合は、使っているシェルの設定に
`export PATH="$HOME/.local/bin:$PATH"` を追加する。

## ASM

Nixvim と Lua 版の両方で `asm_lsp` を有効化。
Neovim 標準の `.asm` / `.s` / `.S` → `asm`、`.nasm` → `nasm` 判定を利用し、
`asm` / `nasm` / `vmasm` バッファで接続する。
補完は nvim-cmp、ホバーは `K`、診断移動は `[d` / `]d`。

Nixvim 側は asm-lsp と、診断・アセンブル用の GCC / NASM も提供する。
反映は通常どおり `sh update-home.sh`。この作業では Home Manager の切替は行わない。
Lua 版ではこれらの実行ファイルを別途インストールする。

構文・命令セットはグローバル固定せず、プロジェクトルートの `.asm-lsp.toml` で選ぶ。
GAS / x86-64 の例:

```toml
[default_config]
assembler = "gas"
instruction_set = "x86-64"

[default_config.opts]
compiler = "gcc"
diagnostics = true
default_diagnostics = true
```

NASM では `assembler = "nasm"`、`compiler = "nasm"` に変更する。
ビルド固有のフラグ・インクルードパスは `compile_commands.json` / `compile_flags.txt` で指定する。
ARM / RISC-V などでは、命令セットと診断用クロスコンパイラをプロジェクトに合わせて指定する。
ASM のフォーマッタは追加していない。
設定項目の詳細: [asm-lsp](https://github.com/bergercookie/asm-lsp#optional-configure-via-asm-lsptoml)。

## 動作確認

リポジトリと独立した作業ディレクトリで、設定をロードして実行する:

```sh
repo=/path/to/dotfiles
work=$(mktemp -d)
cd "$work"
nvim --headless -u "$repo/pastel/programs/neovim/init.lua" \
  -c "luafile $repo/tests/neovim/smoke.lua"
nvim --headless -u "$repo/pastel/programs/neovim/init.lua" \
  -c "luafile $repo/tests/neovim/asm.lua"
```

`smoke.lua` はスニペット展開、Rust 保存時整形、バッファ切替、Telescope、Neo-tree、
ターミナル開閉を確認する。`rustfmt` が必要。
`asm.lua` は GAS / NASM それぞれで接続・MOV のホバーと補完・不正命令の診断・
修正後の診断消去を確認する。`asm-lsp` / `gcc` / `nasm` が必要。
Nixvim 版の ASM 確認には `-u ...` を外し、更新した Nixvim で同じ `asm.lua` を実行できる。

Ubuntu の一般ユーザーで導入手順全体を確認するには、次を実行する。
一時 HOME に実際のパッケージをダウンロードし、2ファイルでの導入、既存設定の保護、
再実行時のバックアップ、導入した `pnvim` での ASM 動作を確認してから一時環境を削除する:

```sh
sh tests/neovim/install.sh
```
