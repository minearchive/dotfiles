import { COMPOSITOR } from "shoji_wm";

// API references: docs/docs/configuration/{input,outputs,cursor,processes-and-env}.md
COMPOSITOR.env.apply({
  GTK_IM_MODULE: "fcitx", QT_IM_MODULE: "fcitx", XMODIFIERS: "@im=fcitx",
  GLFW_IM_MODULE: "fcitx", MATUGEN_SCHEME: "dark",
  XDG_CURRENT_DESKTOP: "ShojiWM", XDG_SESSION_DESKTOP: "ShojiWM", XDG_SESSION_TYPE: "wayland",
});
COMPOSITOR.cursor.configure({ theme: "Bibata-Modern-Ice", size: 24 });
COMPOSITOR.env.publish();

COMPOSITOR.input.configure(input => {
  input.global = {
    keyboard: { layout: "jp", repeatDelay: 400, repeatRate: 60 },
    pointer: { accelProfile: "flat", pointerAccel: 0.5 },
    touchpad: { naturalScroll: true, tapToClick: true, disableWhileTyping: true, pointerAccel: 0.3 },
  };
});
COMPOSITOR.output.configure(() => ({
  "HDMI-A-1": { mode: "extend", resolution: { width: 1920, height: 1080, refreshRate: 60 }, position: { x: 0, y: 0 }, scale: 1 },
  "DVI-D-1": { mode: "extend", resolution: { width: 1280, height: 1024, refreshRate: 60 }, position: { x: 1920, y: 0 }, scale: 1 },
  "eDP-1": { mode: "extend", resolution: { width: 1920, height: 1200, refreshRate: 60 }, position: { x: 0, y: 0 }, scale: 1 },
}));

COMPOSITOR.process.once("pastel.keyring", {
  command: ["gnome-keyring-daemon", "--start", "--components=pkcs11,secrets,ssh"],
  runPolicy: "once-per-session",
});
COMPOSITOR.process.once("pastel.wallpaper-daemon", { command: ["swww-daemon"], runPolicy: "once-per-session" });
COMPOSITOR.process.once("pastel.input-method", { command: ["fcitx5", "-d", "--replace"], runPolicy: "once-per-session" });
COMPOSITOR.process.once("pastel.wallpaper", {
  command: `for attempt in $(seq 1 50); do
    if swww query >/dev/null 2>&1; then
      [ ! -s ~/.config/wallpaper.info ] || swww img "$(cat ~/.config/wallpaper.info)" --transition-type none --transition-duration 0
      exit
    fi
    sleep 0.1
  done`,
  runPolicy: "once-per-session",
});
COMPOSITOR.process.once("pastel.shell", { command: "cd ~/shell && exec quickshell -p shell.qml", runPolicy: "once-per-session" });
