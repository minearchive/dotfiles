# nixvim plugins with unfree licenses (`presence.nvim`)

**Problem:** `./update-home.sh` aborted during evaluation with

```
error: Refusing to evaluate package 'vimplugin-presence.nvim-<hash>' in ...: package ... has an unfree license ('unfree'), refusing to evaluate.
```

**Fix:** `pastel/programs/neovim.nix`

```nix
programs.nixvim.nixpkgs.config.allowUnfreePredicate =
  pkg: builtins.elem (pkgs.lib.getName pkg) [ "presence.nvim" ];
```

---

## Why `config.allowUnfree = true` in the flake does not work

`flake.nix` already sets `config.allowUnfree = true`, but that config belongs to the
flake's own nixpkgs. **nixvim imports its own nixpkgs** — see
`<nixvim>/modules/top-level/nixpkgs.nix`, which builds its package set via
`import cfg.source (args // systemArgs)` — so the flake-level `config.allowUnfree`
never reaches vim plugins.

The relevant option is nixvim's own `programs.nixvim.nixpkgs.config`, whose type is
`nixpkgs-config`. It accepts the usual nixpkgs config keys, including
`allowUnfree`, `allowUnfreePredicate`, `allowBroken`, and `packageOverrides`.

## Why `NIXPKGS_ALLOW_UNFREE=1` masked the problem

`update-home.sh` runs with `NIXPKGS_ALLOW_UNFREE=1 ... --impure`. The env var was
silently supplying the permission, so the build "worked" locally while the
configuration itself was incorrect — any build without that ambient variable would
fail. Prefer the declared predicate and verify without the env var:

```sh
nix build --no-link --print-out-paths '.#homeConfigurations."pastel@msiLaptop".activationPackage'
```

This now succeeds with no `NIXPKGS_ALLOW_UNFREE` and no `--impure`.

## Prefer the predicate over blanket `allowUnfree`

`allowUnfreePredicate` whitelists specific packages, so a future plugin that is
unfree for an unrelated reason still fails loudly instead of slipping in. Add new
names to the list rather than switching to `allowUnfree = true`.

`presence.nvim` is unfree because it communicates over the proprietary Discord IPC
socket. License name appears as `unfree`.
