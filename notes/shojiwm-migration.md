# ShojiWM migration

`pastel/programs/shojiwm.nix` installs the configuration from
`pastel/programs/shojiwm/` directly. `index.tsx` connects the documented
COMPOSITOR APIs, `session.ts` configures input, outputs and startup programs,
and `window-manager.ts` manages scrolling columns and workspaces. `layout.ts`
contains the geometry and column operations, and `animation.ts` the niri animation
parameters. There is no upstream config patch.

The implementation follows `docs/docs/configuration/` in ShojiWM, at the
revision recorded in `flake.lock`. After updating that input, type-check against
the new SDK before switching sessions.

The desktop and laptop NixOS configurations enable both ShojiWM and niri.
The active `pastel` Home Manager configuration installs both configurations.
Apply the NixOS configuration first, then run `sh update-home.sh` for the
active `pastel` Home Manager configuration, and select ShojiWM or niri at login.

## niri parity (animation, keybinding, window layout)

The target is niri's built-in defaults plus the old `pastel/programs/niri.nix`
(its `animations {}` was empty, so niri defaults apply). Sources checked:
`niri-config/src/animations.rs`, `src/layout/{scrolling,monitor,floating}.rs`,
`niri-config/src/recent_windows.rs`.

Layout (`layout.ts`):
- Column width is niri's `(working width - gap) * proportion - gap`, so two
  50% columns fill the screen exactly. Gaps 10px; `Super+G` toggles full width
  (`W - 2*gap`); `Super+B` sets 80%; an interactive resize leaves a fixed width.
- The view offset is stored relative to the active column, as niri does.
  Focusing scrolls only when the column is not fully visible, aligning it to
  the nearer edge. Closing a column you just opened returns to the column and
  view it came from; otherwise the right neighbour slides into its place.
- Workspaces are dynamic: empty inactive ones are removed and there is
  always one empty workspace at the end. `Super+N`/`Super+Alt+N` clamp to it.
  A disconnected output's workspaces move to another output and back again
  when it reconnects.
- The focus ring is 1px, `#7fc8ff` (`#505050` on an unfocused output), drawn
  outside the client. The border was width 0 in niri, so it is not drawn.
- Client maximize requests fill the working area without gaps; minimize
  requests are ignored (niri has no minimize).
- Floating: `Super+Shift+arrows` move the window by 50px, `Super+Left/Right`
  focus the nearest floating window in that direction.
- focus-follows-mouse with max-scroll-amount 0% only focuses windows that
  are already fully visible.

Animation (`animation.ts`):
- open: 150ms ease-out-expo, opacity 0→1 and scale 0.5→1.
- close: 150ms ease-out-quad, opacity 1→0 and scale 1→0.8.
- view movement, window movement and resize: spring with stiffness 800
  (326ms); workspace switch: spring with stiffness 1000 (291ms). The slide
  covers output height + 10% gap per workspace, with no fade.
- `scheduleAnimation` only supports Bézier curves, so springs use the
  approximation `cubic-bezier(0.289, 0.48, 0.031, 1)` (max error 2.2%).
  The overview (TypeScript-driven) uses the exact spring formula. When an
  animation is retargeted, it continues from the current position on screen.

Overview: `Super+Tab`, the top-left hot corner (1px), or a four-finger swipe
up/down. Zoom is 0.5, with workspaces stacked vertically and a gap of 10% of
the height. Clicking a window focuses it and closes the overview. Three-finger
horizontal swipes scroll the view with niri's inertia and snap to a column
edge. Three-finger vertical swipes switch by 300 units per workspace.

Known differences:
- ShojiWM cannot detect when Alt is released, so Alt+Tab / Alt+Shift+Tab
  (and Alt/Super+grave for the same app) have no preview UI. Pressing again
  within 1s goes further back; otherwise the chosen window becomes the most
  recent. Moving the pointer without Alt also ends the cycle.
- Workspace switching via vertical swipe does not follow the fingers in real time.
- The overview does not support mouse-wheel workspace switching or drag-and-drop.
- The key binding API has no allow-when-locked, so volume and brightness keys
  do not work while the screen is locked.

The NixOS module's initConfig only supplies SDK/editor support files. Home
Manager owns src/. Hot reload preserves workspace membership, floating state,
column widths, view position, fullscreen state and the recently-used window order
(snapshot key `pastel.scrolling-wm.v2`).

The transition tests use a small SDK mock and do not launch a compositor:

```sh
nix run nixpkgs#esbuild -- tests/shojiwm/window-manager.test.ts --bundle --platform=node --format=cjs --alias:shoji_wm=./tests/shojiwm/sdk.ts --outfile=/tmp/shojiwm-tests.cjs
node /tmp/shojiwm-tests.cjs
```

Validation performed: TypeScript type checking against the locked ShojiWM SDK,
the transition tests above, and both pastel Home Manager evaluations. Live
rendering, client interaction and session locking still need verification in a
ShojiWM session. In particular, the scale animations through `window.transform` and
the signal-driven overview transform have not been tested on real hardware.
