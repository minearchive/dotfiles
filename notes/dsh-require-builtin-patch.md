# `dsh` require-builtin patch: do not reinstate

**Problem:** After bumping the flake lock, `./update-home.sh` failed while building
`dsh`:

```
pattern 'createRequire(import.meta.url)("node-addon-require-builtin")' doesn't match anything
```

(`--replace-fail` turns a non-matching substitution into a hard build failure.)

**Fix:** Removed the `agents.dsh.overrideAttrs` block in `pastel/tools.nix`; plain
`agents.dsh` is enough. See the pointer comment next to it.

---

## Background

`dsh` used to need a shim so its addon loader received a `requireBuiltin`
function. The dotfiles patched this at install time with `substituteInPlace`:

```nix
(agents.dsh.overrideAttrs (old: {
  postInstall = (old.postInstall or "") + ''
    substituteInPlace \
      $out/lib/node_modules/@deepseek-ai/dsh/node_modules/@deepseek-ai/dsh-app-boot/lib/index.js \
      --replace-fail \
      'createRequire(import.meta.url)("node-addon-require-builtin")' \
      '{ requireBuiltin: createRequire(import.meta.url) }'
  '';
}))
```

**Upstream fixed this in `dsh` 0.2.1-rc.3.** The shipped source now already contains
the patched form:

```js
const addon = { requireBuiltin: createRequire(import.meta.url) };
```

so the old pattern no longer exists and the patch breaks the build. It was needed
for `0.2.0-rc.2` and earlier only.

## Secondary detail: the comment named the wrong file

The removed comment pointed at
`.../@deepseek-ai/dsh-app-boot/lib/index.js`, but in `0.2.0-rc.2` the pattern
actually lived in `worker/profile-resolution-bootstrap.js`. The substitution still
"succeeded" because `--replace-fail` matched in whichever file was targeted. When
resurrecting this kind of patch, locate the pattern first:

```sh
grep -rn 'node-addon-require-builtin' $(readlink -f $(command -v dsh))/..
```

## Verify a bump landed correctly

```sh
dsh --version   # expect 0.2.1-rc.3 or newer
```

If a future `dsh` upgrade breaks the build with a missing-pattern error again, check
whether upstream moved the shim rather than re-adding the override.

## Unrelated: `dsh install` is not a command

`dsh` is a **profile launcher**, not a package installer. Its only subcommand is
`plugin`; any other first positional argument is treated as a *profile name*, so
`dsh install` fails with:

```
Error: dsh: profile "install" does not exist; create it with 'dsh plugin --profile install add <package>'
```

Correct invocations:

```sh
dsh web                                       # boot the web profile
dsh plugin --profile <name> add <package>     # install a plugin into a profile
dsh <name> --from-default-profile web         # create a profile from a template
```

To upgrade `dsh` itself, update the flake input (`nix flake update llm-agents-nix`)
and re-run `./update-home.sh` — there is no self-install subcommand.
