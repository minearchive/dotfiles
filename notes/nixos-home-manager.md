# NixOS / Home Manager operational notes

## Hermes

Hermes container `extraOptions` are inserted into a shell command. Wrap arguments containing spaces, such as `NIX_CONFIG`, with `lib.escapeShellArg`.

Hermes runs in **rootful Podman**, not Docker or the user's rootless Podman. Inspect stopped containers with `sudo podman ps -a` and startup failures with `journalctl -u hermes-agent.service -n 100 --no-pager`.

The shared host configuration patches the upstream container entrypoint to use `gpg --batch --yes --dearmor`, so interrupted first-boot provisioning can overwrite the NodeSource keyring without requiring a TTY.

## WARP

WARP 2026.7 calls `/usr/sbin/nft` directly. The shared configuration supplies that path through a read-only bind mount in a service-private `/usr`, preserving `/usr/bin`; installing `nft` on `PATH` alone does not fix `FirewallUpdateFailed`. After rebuilding, run `sudo systemctl restart warp-svc`, `warp-cli connect`, then `warp-cli status` and `curl --max-time 20 https://www.cloudflare.com/cdn-cgi/trace` (expect `Connected` and `warp=on`). Registration does not need to be deleted.

## MathWorks Service Host

MathWorks Service Host needs `libpam.so.0`, supplied by `linux-pam` in the shared `programs.nix-ld.libraries`. If its autostart unit fails with that missing-library error, apply the host configuration with `sudo nixos-rebuild switch --flake .#<host>`, then run `systemctl --user restart 'app-mathworks\x2dservice\x2dhost@autostart.service'`. Verify with `systemctl --user is-active 'app-mathworks\x2dservice\x2dhost@autostart.service'`.

## Google Colab CLI

The `pastel` profile provides `colab` and `colab-cli` for [Google Colab CLI](https://github.com/googlecolab/google-colab-cli), pinned to version 0.7.4. Both launch the official `colab` command through `uv` with Nix-provided Python; the first run downloads dependencies and requires network access. After applying Home Manager, run `colab-cli --help` or `colab version`.

If previously installed with `uv tool install`, run `uv tool uninstall google-colab-cli` to remove the old `~/.local/bin/colab` launcher, which otherwise takes precedence over the Nix-managed command. Confirm with `type -a colab`.

The launcher adds Nix's C++ runtime to its own `LD_LIBRARY_PATH` for `pyzmq`'s bundled native libraries, preventing `ImportError: libstdc++.so.6` without changing the global shell environment. Check startup independently of inherited library paths with `env -u LD_LIBRARY_PATH -u NIX_LD_LIBRARY_PATH colab --help`.
