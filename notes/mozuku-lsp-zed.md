# MoZuku (t3tra-dev/MoZuku) LSP を Zed で使う

日本語校正LSP `mozuku-lsp` を Zed で使おうとした調査記録。**結論: Zedでは診断（文法チェック）は動くが、目玉のセマンティックハイライトは原理的に表示できない**ため、この統合は一旦見送り、リポジトリからは削除した。VS Code / Neovim では公式プラグインで完全動作する。

## MoZuku とは

- 日本語テキストの解析・校正を行う **stdio LSP サーバー**（バイナリ名 `mozuku-lsp`、C++製）。
- MeCab（形態素解析）+ CaboCha（係り受け）+ CURL（Wikipedia hover）依存。
- flake があり `nix build github:t3tra-dev/MoZuku#default` でビルド可能（`crfpp` / `cabocha` も flake 内でビルド）。成果物は `bin/mozuku-lsp` のみ。

## Zed 統合で判明した3つの壁（時系列）

### 1. dev拡張が必要（settings だけでは外部LSPを生やせない）
Zed は「新規LSPを settings だけで登録」できない。`lsp.<name>.binary.path` は既知サーバーのバイナリ差し替え専用。→ `mozuku-lsp` を PATH から探して stdio 起動するだけの薄い WASM dev拡張を書く必要がある（`extension.toml` + `src/lib.rs`、`zed_extension_api`、`worktree.which("mozuku-lsp")`）。

### 2. Zed はコンパイルターゲットが `wasm32-wasip1` ではなく `wasm32-wasip2`
`install dev extension` 時に Zed がローカルで拡張を Rust→WASM コンパイルする。ログのエラー:
```
= note: the `wasm32-wasip2` target may not be installed
```
nixpkgs の `rustc` は wasm std を同梱しないので、fenix で `wasm32-wasip2` の rust-std を含むツールチェインを合成し、そのシェルから Zed を起動する必要がある（Zed は PATH の cargo/rustc を使う。ログの PATH に `rust-mixed/bin` が入っていれば拾えている）。

### 3. `mozuku-lsp` は起動時に `mecab-config` を PATH に要求する
`mozuku-lsp` は起動時に `popen("mecab-config --dicdir")` で辞書を探し、失敗すると即
```
[ERROR] System MeCab not detected
[ERROR] Failed to initialize MeCab
```
で落ちる（`src/mecab_manager.cpp` の `detectSystemMeCab()`）。upstream パッケージはバイナリ単体なので、`mecab` を PATH に入れてラップする必要がある。`MOZUKU_DEBUG=1` で詳細ログが出る。nixpkgs mecab-0.996 の ipadic 辞書で問題なく初期化できた（`MeCab: OK`）。CaboCha は nixpkgs に無いが、無くても degrade（`CaboCha: N/A`）して動く。

ラップ方法（Home Manager）:
```nix
mozuku-lsp = pkgs.symlinkJoin {
  name = "mozuku-lsp";
  paths = [ inputs.mozuku.packages.${pkgs.system}.default ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/mozuku-lsp \
      --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.mecab ]}
  '';
};
```

## 最終的な壁（これが致命的）: ハイライトが独自プロトコル

上記3つを全て解決し、Zed は `mozuku-lsp` を正常に spawn・管理できた（手動バックグラウンド起動は不要）。しかし Zed ログに大量に:
```
Language server ... sent unhandled notification mozuku/semanticHighlights
                                                mozuku/commentHighlights
                                                mozuku/contentHighlights
```

- MoZuku は品詞ハイライトを **独自通知 `mozuku/*Highlights`（非標準LSP）** で push している。
- 標準の `textDocument/semanticTokens/full` は **`null`** を返す（`semanticTokensProvider` を宣言はするが中身は空）。
- Zed はこの独自通知を無視する。そして **Zed の WASM 拡張 API では独自通知を横取りして装飾を描くことができない** → Zed では色が一切付かない。
- この独自通知を処理する専用クライアントは公式 VS Code / Vim プラグインにしか無い。

### Zed で動く/動かない（実測）
- ✅ **診断（文法チェック）**: 標準 `textDocument/publishDiagnostics` で飛ぶ。例（`私はは学校に行きますた。これがこれがテストです`）で「同じ助詞「は」が連続しています」等 3件。Zed で波線表示される。
- ❌ **セマンティックハイライト**: 独自通知のため表示不可（上記）。
- ❌/△ **hover**: 簡易テストでは `null`。

## 判断

ハイライトが本命なら Zed では satisfy できない。診断だけで良ければ拡張＋mecabラッパで動く。今回は見送り、`flake.nix`（mozuku input）・`pastel/programs/zed.nix`（mozuku-lsp 設定とラッパ）・`pkgs/zed-mozuku/`（拡張一式）は削除した。復活させたい場合は本ノートの手順で再構築可能。

## 参考にした拡張の中身（復元用）

`pkgs/zed-mozuku/extension.toml`:
```toml
id = "mozuku"
name = "MoZuku"
version = "0.0.1"
schema_version = 1

[language_servers.mozuku-lsp]
name = "MoZuku LSP"
languages = ["Markdown", "Plain Text", "C", "C++", "Python", "JavaScript", "TypeScript", "TSX", "Rust"]
```

`pkgs/zed-mozuku/src/lib.rs`（`Cargo.toml`: `zed_extension_api = "0.7.0"`, `crate-type = ["cdylib"]`）:
```rust
use zed_extension_api::{self as zed, LanguageServerId, Result};

struct MozukuExtension;

impl zed::Extension for MozukuExtension {
    fn new() -> Self { Self }
    fn language_server_command(
        &mut self,
        _id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let path = worktree
            .which("mozuku-lsp")
            .ok_or_else(|| "`mozuku-lsp` not found in PATH".to_string())?;
        Ok(zed::Command { command: path, args: Vec::new(), env: worktree.shell_env() })
    }
}

zed::register_extension!(MozukuExtension);
```

ビルド用 devShell（fenix、wasip2 std 込み）は `nix develop -c zed .` で Zed を起動して `install dev extension`。
