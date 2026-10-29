import { COMPOSITOR, ManagedWindow, WindowBorder, ClientWindow, Button } from "shoji_wm";
import "./session";
import { LIFECYCLE, OVERVIEW, lifecycleOpacity, lifecycleScale } from "./animation";
import { overviewTransform } from "./layout";
import { ScrollingWindowManager, VIEW } from "./window-manager";

const wm = new ScrollingWindowManager();
// Lifecycle and reactive composition follow docs/docs/configuration/.
COMPOSITOR.onDisable(event => {
  if (event.isReloading) event.persist("pastel.scrolling-wm.v2", wm.snapshot());
  wm.dispose();
});
COMPOSITOR.onEnable(event => {
  if (event.isReloading) {
    const saved = event.restore<ReturnType<typeof wm.snapshot>>("pastel.scrolling-wm.v2");
    if (saved) wm.restore(saved);
  }
  wm.outputsChanged();
});
COMPOSITOR.event.onOpen(window => wm.add(window));
COMPOSITOR.event.onInitialConfigure(window => wm.initialConfigure(window));
COMPOSITOR.event.onFirstCommit(window => wm.firstCommit(window));
COMPOSITOR.event.onStartClose(window => wm.close(window, false));
COMPOSITOR.event.onClose(window => wm.close(window, true));
COMPOSITOR.event.onFocus((window, focused) => wm.onFocus(window, focused));
COMPOSITOR.event.onPointerMove(event => wm.pointer(event));
COMPOSITOR.event.onOutputChange(() => wm.outputsChanged());
COMPOSITOR.event.onCreateLayer(() => wm.layout());
COMPOSITOR.event.onUpdateLayer(() => wm.layout());
COMPOSITOR.event.onDestroyLayer(() => wm.layout());
COMPOSITOR.event.onWindowResize(event => wm.resize(event));
COMPOSITOR.event.onWindowMove(event => wm.move(event));
COMPOSITOR.event.onWindowFullscreenRequest(event => wm.fullscreen(event.window, event.fullscreen));
COMPOSITOR.event.onWindowMaximizeRequest(event => wm.maximize(event.window, event.maximized));
// niri does not minimize windows, so minimize requests are ignored.
COMPOSITOR.event.onWindowActivateRequest(event => wm.focus(event.window.id));
COMPOSITOR.pointer.bindWindowMoveModifier("Super");
COMPOSITOR.pointer.bindWindowResizeModifier("Super");

// niri touchpad gestures: three fingers scroll the view horizontally or
// switch workspaces vertically, four fingers vertically toggle the overview.
let gesture: { fingers: number; axis?: "horizontal" | "vertical" } | undefined;
COMPOSITOR.event.onGestureSwipe(event => {
  if (event.fingers !== 3 && event.fingers !== 4) return;
  if (event.phase === "begin") { gesture = { fingers: event.fingers }; return; }
  if (!gesture) return;
  if (!gesture.axis && Math.max(Math.abs(event.totalX), Math.abs(event.totalY)) > 8)
    gesture.axis = gesture.fingers === 4 || Math.abs(event.totalY) > Math.abs(event.totalX) ? "vertical" : "horizontal";
  const scrolling = gesture.fingers === 3 && gesture.axis === "horizontal";
  if (event.phase === "update" && scrolling) wm.scrollGesture("update", event.deltaX, 0);
  if (event.phase === "cancel" && scrolling) wm.scrollGesture("end", 0, 0);
  if (event.phase === "end") {
    if (scrolling) wm.scrollGesture("end", 0, event.velocityX);
    else if (gesture.axis === "vertical" && gesture.fingers === 3) wm.workspaceGesture(event.totalY, event.velocityY);
    else if (gesture.axis === "vertical") wm.overviewGesture(event.totalY, event.velocityY);
  }
  if (event.phase === "end" || event.phase === "cancel") gesture = undefined;
});

// prefer-no-csd: ask clients for server-side decorations, which here are only
// niri's focus ring (1px, default colours) drawn outside the client.
COMPOSITOR.window.decoration.configure((window, context) => ({
  mode: window.appId() ? "server" : context.clientPreference ?? "client",
}));
COMPOSITOR.window.composition = window => {
  const view = window.state[VIEW]();
  const lifecycle = window.animation.variable(LIFECYCLE);
  window.transform.scaleX = lifecycle(lifecycleScale);
  window.transform.scaleY = lifecycle(lifecycleScale);
  window.transform.opacity = lifecycle(lifecycleOpacity);
  const transform = view.overview
    ? window.animation.variable(OVERVIEW)(progress => overviewTransform(view.rect, view.outputRect, view.position, progress))
    : {};
  const ring = view.ring === "active" ? "#7fc8ff" : view.ring === "inactive" ? "#505050" : "#00000000";
  return (
    <ManagedWindow rect={view.rect} workspace={view.workspace} visibleOutputs={[view.output]}
      visible={view.visible} idle={!view.active} interactive={view.active}
      forceRectSize={view.fullscreen || view.tiled || window.isResizable()} tiled={view.tiled} zIndex={view.zIndex}
      transform={transform}>
      {view.fullscreen && !view.overview ? <ClientWindow /> : (
        <WindowBorder style={{ position: "relative", border: { px: view.fullscreen ? 0 : 1, color: ring }, borderRadius: 0 }}
          interaction={{ resizeHitArea: view.overview ? 0 : { edgePx: 8, cornerPx: 14 } }}>
          <ClientWindow />
          {view.overview && <Button onClick={() => wm.selectPreview(window.id)}
            style={{ position: "absolute", inset: 0, width: "100%", height: "100%", zIndex: 1, background: "#00000000" }} />}
        </WindowBorder>
      )}
    </ManagedWindow>
  );
};

// Binds from the pastel niri config (pastel/programs/niri.nix).
const command = (id: string, shortcut: string, command: string | string[]) =>
  COMPOSITOR.key.bind(id, shortcut, () => { COMPOSITOR.process.spawn({ command }); });
command("terminal", "Super+T", ["kitty"]);
command("browser", "Super+F", ["zen-beta"]);
command("files", "Super+E", ["nautilus"]);
command("lock", "Super+L", ["hyprlock"]);
command("launcher", "Super+R", ["rofi", "-show", "run"]);
command("logout", "Super+P", ["wlogout"]);
// quit skip-confirmation=false
command("quit-confirmation", "Ctrl+Alt+Delete", `zenity --question --title='Quit ShojiWM' --text='Log out of this session?' && loginctl terminate-session "$XDG_SESSION_ID"`);
command("settings", "Super+I", "XDG_CURRENT_DESKTOP=gnome gnome-control-center");
command("picker", "Super+N", ["hyprpicker", "-a"]);
command("screenshot-region", "Super+Shift+S", `grim -g "$(slurp)" - | wl-copy`);
command("screenshot-full", "Shift+Print", `mkdir -p ~/Pictures/screenshots && grim - | wl-copy && wl-paste > ~/Pictures/screenshots/Screenshot-$(date +%F_%T).png && dunstify 'Screenshot taken' -t 1000`);
command("wallpaper", "Super+Shift+Ctrl+T", "~/.config/shojiwm/wallpaper_change.sh");
command("mute", "XF86AudioMute", ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
command("volume-up", "XF86AudioRaiseVolume", ["wpctl", "set-volume", "-l", "1.4", "@DEFAULT_AUDIO_SINK@", "5%+"]);
command("volume-down", "XF86AudioLowerVolume", ["wpctl", "set-volume", "-l", "1.4", "@DEFAULT_AUDIO_SINK@", "5%-"]);
command("brightness-up", "XF86MonBrightnessUp", ["brightnessctl", "set", "+5%"]);
command("brightness-down", "XF86MonBrightnessDown", ["brightnessctl", "set", "5%-"]);
COMPOSITOR.key.bind("close", "Super+Q", () => wm.closeFocused());
COMPOSITOR.key.bind("floating", "Super+D", () => wm.toggleFloating());
COMPOSITOR.key.bind("maximize-column", "Super+G", () => wm.maximizeColumn());
COMPOSITOR.key.bind("fullscreen", "Super+K", () => wm.toggleFullscreen());
COMPOSITOR.key.bind("column-eighty", "Super+B", () => wm.setColumnWidth(0.8));
COMPOSITOR.key.bind("overview", "Super+Tab", () => wm.toggleOverview());
for (let index = 1; index <= 9; index++) {
  COMPOSITOR.key.bind(`workspace-${index}`, `Super+${index}`, () => wm.focusWorkspace(index));
  COMPOSITOR.key.bind(`move-${index}`, `Super+Alt+${index}`, () => wm.moveToWorkspace(index, false));
  COMPOSITOR.key.bind(`move-follow-${index}`, `Super+Alt+Shift+${index}`, () => wm.moveToWorkspace(index, true));
}
COMPOSITOR.key.bind("focus-left", "Super+Left", () => wm.focusColumn(-1));
COMPOSITOR.key.bind("focus-right", "Super+Right", () => wm.focusColumn(1));
COMPOSITOR.key.bind("workspace-up", "Super+Up", () => wm.switchWorkspace(-1));
COMPOSITOR.key.bind("workspace-down", "Super+Down", () => wm.switchWorkspace(1));
COMPOSITOR.key.bind("move-left", "Super+Shift+Left", () => wm.moveColumn(-1));
COMPOSITOR.key.bind("move-right", "Super+Shift+Right", () => wm.moveColumn(1));
COMPOSITOR.key.bind("move-up", "Super+Shift+Up", () => wm.moveVertical(-1));
COMPOSITOR.key.bind("move-down", "Super+Shift+Down", () => wm.moveVertical(1));
// niri's built-in recent-windows binds (Mod+Tab is taken by the overview).
COMPOSITOR.key.bind("recent-next", "Alt+Tab", () => wm.mruStep(1, false));
COMPOSITOR.key.bind("recent-previous", "Alt+Shift+Tab", () => wm.mruStep(-1, false));
COMPOSITOR.key.bind("recent-app-next", "Alt+grave", () => wm.mruStep(1, true));
COMPOSITOR.key.bind("recent-app-previous", "Alt+Shift+grave", () => wm.mruStep(-1, true));
COMPOSITOR.key.bind("recent-app-next-mod", "Super+grave", () => wm.mruStep(1, true));
COMPOSITOR.key.bind("recent-app-previous-mod", "Super+Shift+grave", () => wm.mruStep(-1, true));
