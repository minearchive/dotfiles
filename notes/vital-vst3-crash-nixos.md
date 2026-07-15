# Vital VST3 crashes in Bitwig (NixOS)

## Quick Summary

**Problem:** Vital VST3 crashes immediately in Bitwig. CLAP loads but GUI is black.  
**Fix:** Override `vital` in nixpkgs to add `libcurl.so.4` to the plugin `.so` NEEDED section via `preFixup`.  
**File:** `pastel/hosts/desktop.nix`

---

## Diagnostic Information

### Where to look first

1. **Bitwig log** — `~/.BitwigStudio/log/BitwigStudio.log`  
   Look for lines with `error` around plugin load events. The key line was:
   ```
   Engine failed to load plug-in: Plugin host died: Could not read repsonses: End of stream
   ```

2. **Kernel journal** — this is where the real crash info is, not the Bitwig log:
   ```bash
   journalctl -b | grep -i "BitwigPlugin\|segfault\|vital"
   ```
   This revealed the actual segfault:
   ```
   BitwigPluginHos[66572]: segfault at 40 ip 000072ebeac111b5 in Vital.so[2111b5,...]
   ```

3. **Decode the crash address** with `objdump`:
   ```bash
   objdump -d ~/.nix-profile/lib/vst3/Vital.vst3/Contents/x86_64-linux/Vital.so \
     | awk '/211180:/,/2111d0/'
   ```
   This showed the crash was inside `juce::WebInputStream::Pimpl` trying to call a libcurl function pointer that was NULL.

4. **Check RPATH of the plugin** to confirm missing libraries:
   ```bash
   objdump -p ~/.nix-profile/lib/vst3/Vital.vst3/Contents/x86_64-linux/Vital.so | grep RUNPATH
   ```
   `libcurl` was absent from the RPATH, while it was present for the standalone `Vital` binary.

5. **Check nixpkgs package source** for context:
   ```bash
   gh api repos/NixOS/nixpkgs/contents/pkgs/by-name/vi/vital/package.nix --jq '.content' | base64 -d
   ```
   Confirmed that `curl` was only passed to `wrapProgram` for the binary, not added to `buildInputs`.

---

## What Was Tried and Why It Didn't Work

### `BITWIG_PLUGIN_SANDBOX_DISABLED=1` (environment variable)
Did not help. The crash is not a sandbox access issue — the plugin host process itself crashes due to a NULL pointer inside `Vital.so`.

### `postInstall` hook with `patchelf --add-rpath`
```nix
postInstall = '' patchelf --add-rpath ${pkgs.curl.out}/lib "$plugin" '';
```
Did not work. `autoPatchelfHook` runs in `postFixupHooks` which executes as part of `runHook postFixup` — AFTER `$postInstall` and AFTER `$postFixup`, but still within the same `runHook postFixup` call. It uses `patchelf --set-rpath` which replaces any RPATH changes made earlier.

### `postFixup` hook with `patchelf --add-rpath`
```nix
postFixup = '' patchelf --add-rpath ${pkgs.curl.out}/lib "$plugin" '';
```
Same problem. `runHook postFixup` in nixpkgs stdenv runs `$postFixup` first, then iterates `$postFixupHooks[@]` — so `autoPatchelfPostFixup` still runs after and overwrites the RPATH.

The relevant `runHook` implementation (`pkgs/stdenv/generic/setup.sh`):
```bash
runHook() {
    local hooksSlice="${hookName%Hook}Hooks[@]"
    for hook in "_callImplicitHook 0 $hookName" ${!hooksSlice+"${!hooksSlice}"}; do
        _eval "$hook" "$@"  # $postFixup runs first, then postFixupHooks (autoPatchelf)
    done
}
```
And `autoPatchelfHook` registers via:
```bash
postFixupHooks+=(autoPatchelfPostFixup)  # in autoPatchelfHook's setup-hook
```

---

## Final Solution

Add `libcurl.so.4` to the plugin `.so` NEEDED section in `preFixup`, and add `curl` to `buildInputs`. When `autoPatchelfHook` then runs, it sees libcurl as a declared dependency, finds it in `buildInputs`, and adds the path to RPATH itself.

```nix
# pastel/hosts/desktop.nix
let
  vital-fixed = pkgs.vital.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.curl ];
    preFixup = (oldAttrs.preFixup or "") + ''
      for plugin in \
        $out/lib/vst3/Vital.vst3/Contents/x86_64-linux/Vital.so \
        $out/lib/clap/Vital.clap/Contents/x86_64-linux/Vital.so \
        $out/lib/vst/Vital.so; do
        [ -f "$plugin" ] && patchelf --add-needed libcurl.so.4 "$plugin"
      done
    '';
  });
in
{
  home.packages = [ vital-fixed ];
  ...
}
```

Apply with:
```bash
home-manager switch --flake .#"pastel@desktop"
```

Verify the fix:
```bash
objdump -p ~/.nix-profile/lib/vst3/Vital.vst3/Contents/x86_64-linux/Vital.so \
  | grep -E "RUNPATH|NEEDED.*curl"
```
curl's nix store path should appear in RUNPATH, and `libcurl.so.4` in NEEDED.

---

## CLAP Black Screen (separate issue, unresolved)

After the libcurl fix, VST3 works fully. CLAP loads but the GUI is a black unresponsive window — this is a separate bug in Vital's JUCE CLAP implementation on Linux with Bitwig, unrelated to libcurl.

**Use VST3.** Do not waste time trying to fix CLAP; it is a Vital upstream bug.

- https://forum.vital.audio/t/linux-black-screen-not-rendering-clap-only/19170
- https://forum.vital.audio/t/vital-1-5-3-in-bitwig-linux-clap-crashes-while-launching-the-ui-no-midi-signal-with-the-vst3-while-ui-in-the-foreground/10776
