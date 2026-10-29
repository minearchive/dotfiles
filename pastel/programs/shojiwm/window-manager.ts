import {
  COMPOSITOR, createWindowState,
  type WaylandWindow, type PointerMoveEvent, type WindowMoveEvent, type WindowResizeEvent,
} from "shoji_wm";
import {
  CLOSE_MS, LIFECYCLE, MOVEMENT_MS, OPEN_MS, OVERVIEW, SPRING_CURVE, WORKSPACE_SWITCH_MS,
  easeOutExpo, easeOutQuad, overviewEasing, springCurveAt,
} from "./animation";
import {
  DEFAULT_WIDTH, GAP, OVERVIEW_ZOOM, RING, WORKSPACE_GAP,
  activateColumn, columnIndexOf, columnWidth, columnX, expand, fitOffset, isEmpty,
  moveVertical, newWorkspace, removeColumn, removeWindow, tileRects, viewPos,
  type ColumnWidth, type Rect, type Workspace,
} from "./layout";

export interface View {
  // Managed rect: the client rect plus the focus ring around it.
  rect: Rect;
  visible: boolean;
  active: boolean;
  tiled: boolean;
  fullscreen: boolean;
  ring: "active" | "inactive" | "none";
  // Overview open or still animating; `position` is the workspace index
  // relative to the active one and `outputRect` the full output.
  overview: boolean;
  position: number;
  outputRect: Rect;
  workspace: string;
  output: string;
  zIndex: number;
}
export const VIEW = createWindowState<View>("pastel.view", {
  default: window => ({
    rect: window.rect, visible: false, active: false, tiled: false, fullscreen: false, ring: "none",
    overview: false, position: 0, outputRect: window.rect, workspace: "", output: "", zIndex: 0,
  }),
});

interface Placement {
  workspace: string;
  floating: boolean;
  manualFloating: boolean | null;
  width: ColumnWidth;
  // Client rect, without the focus ring.
  floatingRect: Rect;
  fullscreen: boolean;
  maximized: boolean;
}
interface Entry extends Placement {
  window: WaylandWindow;
  closing: boolean;
  dispose: (() => void)[];
  motion?: { delta: Rect; start: number };
}
interface Snapshot {
  serial: number;
  outputs: [string, string[]][];
  spaces: Workspace[];
  active: [string, string][];
  currentOutput: string;
  focusedId?: string;
  mru: string[];
  placements: [string, Placement][];
}
const SWITCH = "pastel.workspace";
const MOTION = "pastel.layout";
// niri floating.rs DIRECTIONAL_MOVE_PX.
const FLOATING_STEP = 50;
// niri swipe_tracker.rs / scrolling.rs / monitor.rs gesture constants.
const DECELERATION = -1 / (1000 * Math.log(0.997));
const VIEW_GESTURE_MOVEMENT = 1200;
const WORKSPACE_GESTURE_MOVEMENT = 300;
// Without a modifier-release event the Alt+Tab cycle ends after this pause.
const MRU_COMMIT_MS = 1000;
const floatingTitle = /^(Open File|Select a File|Choose wallpaper|Open Folder|Save As|Library|File Upload)|(wants to save|wants to open)$/;
const floatingApp = /^org\.gnome\.clocks$|^pinentry-/;
const clocks = (window: WaylandWindow) => window.appId() === "org.gnome.clocks";
const zero: Rect = { x: 0, y: 0, width: 0, height: 0 };
const shrink = (rect: Rect): Rect => expand(rect, -RING);

export class ScrollingWindowManager {
  private spaces = new Map<string, Workspace>();
  private order = new Map<string, string[]>();
  private active = new Map<string, string>();
  private windows = new Map<string, Entry>();
  private restored = new Map<string, Placement>();
  private currentOutput = "";
  private focusedId?: string;
  private mru: string[] = [];
  private cycle?: { list: string[]; index: number; timer: ReturnType<typeof setTimeout> };
  private overviewOpen = false;
  private overviewShown = false;
  private hotCorner = false;
  private serial = 0;
  private stack = new Map<string, number>();
  private grabbing = false;
  private switching = new Map<string, number>();
  private timers = new Set<ReturnType<typeof setTimeout>>();

  constructor() {
    COMPOSITOR.workspace.configure(() => ({
      groups: COMPOSITOR.output.list.map(output => ({
        id: output, outputs: [output],
        workspaces: this.list(output).map((space, index) => ({
          id: space.id, name: String(index + 1), coordinates: [index],
          active: this.activeSpace(output) === space,
        })),
      })),
    }));
    COMPOSITOR.workspace.event.onActivate(event => {
      const space = this.spaces.get(event.workspaceId);
      if (space) this.activate(space);
    });
  }

  private later(ms: number, run: () => void): void {
    const timer = setTimeout(() => { this.timers.delete(timer); run(); }, ms);
    this.timers.add(timer);
  }
  private output(): string {
    if (!COMPOSITOR.output.list.includes(this.currentOutput)) this.currentOutput = COMPOSITOR.output.list[0] ?? "";
    return this.currentOutput;
  }
  private full(output: string): Rect {
    const info = COMPOSITOR.output.get(output);
    return { x: info?.position.x ?? 0, y: info?.position.y ?? 0,
      width: (info?.resolution?.width ?? 1920) / (info?.scale ?? 1),
      height: (info?.resolution?.height ?? 1080) / (info?.scale ?? 1) };
  }
  private area(output: string): Rect { return COMPOSITOR.layer.usableArea(output) ?? this.full(output); }
  private create(output: string): Workspace {
    const space = newWorkspace(`ws-${++this.serial}`, output);
    this.spaces.set(space.id, space);
    return space;
  }
  // niri keeps exactly one empty workspace at the end of every output.
  private list(output: string): Workspace[] {
    let ids = this.order.get(output);
    if (!ids) this.order.set(output, ids = []);
    const last = this.spaces.get(ids[ids.length - 1] ?? "");
    if (!last || !isEmpty(last)) ids.push(this.create(output).id);
    return ids.map(id => this.spaces.get(id)!);
  }
  private activeSpace(output: string): Workspace {
    const spaces = this.list(output);
    return spaces.find(space => space.id === this.active.get(output)) ?? spaces[0];
  }
  // niri clean_up_workspaces: drop empty workspaces other than the active and last one.
  private cleanup(output: string): void {
    const spaces = this.list(output);
    const active = this.activeSpace(output);
    const kept = spaces.filter((space, index) => !isEmpty(space) || space === active || index === spaces.length - 1);
    for (const space of spaces) if (!kept.includes(space)) this.spaces.delete(space.id);
    this.order.set(output, kept.map(space => space.id));
    this.active.set(output, active.id);
  }
  private spaceOf(entry: Placement): Workspace {
    const space = this.spaces.get(entry.workspace);
    if (space) return space;
    const fallback = this.activeSpace(this.output());
    entry.workspace = fallback.id;
    return fallback;
  }
  private focused(): Entry | undefined { return this.focusedId ? this.windows.get(this.focusedId) : undefined; }
  private activeWindow(space: Workspace): string | undefined {
    if (space.floatingActive && space.floatingFocus) return space.floatingFocus;
    return space.columns[space.activeColumn]?.active ?? space.floatingFocus;
  }
  private shouldFloat(window: WaylandWindow): boolean {
    return window.isTransient() || !window.isResizable() ||
      floatingTitle.test(window.title()) || floatingApp.test(window.appId() ?? "");
  }
  private centered(output: string, width: number, height: number): Rect {
    const area = this.area(output);
    width = Math.min(area.width - GAP * 2, width);
    height = Math.min(area.height - GAP * 2, height);
    return { x: area.x + (area.width - width) / 2, y: area.y + (area.height - height) / 2, width, height };
  }

  // niri add_column: new columns go right of the active one; activating one
  // remembers the view so closing it returns to the previous column.
  private insert(space: Workspace, id: string, floating: boolean, activate: boolean): void {
    const entry = this.windows.get(id);
    if (floating) {
      space.floating.push(id);
      if (activate || !space.floatingFocus) space.floatingFocus = id;
      if (activate) space.floatingActive = true;
      return;
    }
    const area = this.area(space.output);
    const full = this.full(space.output);
    const index = space.activeColumn < 0 ? 0 : space.activeColumn + 1;
    space.columns.splice(index, 0, { windows: [id], active: id, width: entry?.width ?? DEFAULT_WIDTH, fullWidth: false, mode: "normal" });
    if (space.activeColumn < 0) {
      space.activeColumn = 0;
      space.viewOffset = fitOffset(space, area, full, 0, 0);
    } else if (activate) {
      const previous = space.viewOffset;
      activateColumn(space, area, full, index);
      space.prevOffset = previous;
    }
    if (activate) space.floatingActive = false;
  }
  private syncModes(space: Workspace): void {
    for (const column of space.columns) {
      const entries = column.windows.map(id => this.windows.get(id)).filter(entry => entry && !entry.closing) as Entry[];
      column.mode = entries.some(entry => entry.fullscreen) ? "fullscreen" : entries.some(entry => entry.maximized) ? "maximized" : "normal";
    }
  }

  add(window: WaylandWindow): void {
    if (this.windows.has(window.id)) return;
    const saved = this.restored.get(window.id);
    const parent = this.windows.get(window.parentId() ?? "");
    const space = (saved && this.spaces.get(saved.workspace)) || (parent && this.spaceOf(parent)) || this.activeSpace(this.output());
    const entry: Entry = {
      workspace: space.id, floating: this.shouldFloat(window), manualFloating: null,
      width: clocks(window) ? { fixed: 800 } : DEFAULT_WIDTH,
      floatingRect: this.centered(space.output, clocks(window) ? 800 : Math.max(320, window.rect.width), Math.max(240, window.rect.height)),
      fullscreen: window.isFullscreen(), maximized: window.isMaximized(),
      ...saved, window, closing: false, dispose: [],
    };
    this.windows.set(window.id, entry);
    this.stack.set(window.id, ++this.serial);
    this.mru.push(window.id);
    window.animation.set(OVERVIEW, this.overviewOpen ? 1 : 0);
    if (!space.columns.some(column => column.windows.includes(window.id)) && !space.floating.includes(window.id))
      this.insert(space, window.id, entry.floating, true);
    const classify = () => {
      if (entry.closing) return;
      if (clocks(window) && "proportion" in entry.width) {
        entry.width = { fixed: 800 };
        const column = this.spaceOf(entry).columns.find(column => column.windows.includes(window.id));
        if (column) column.width = entry.width;
        entry.floatingRect = this.centered(this.spaceOf(entry).output, 800, entry.floatingRect.height);
      }
      if (entry.manualFloating === null) this.setFloating(entry, this.shouldFloat(window));
      this.layout(false);
    };
    entry.dispose = [window.title.subscribe(classify), window.appId.subscribe(classify),
      window.isTransient.subscribe(classify), window.isResizable.subscribe(classify)];
    this.layout(false);
  }

  initialConfigure(window: WaylandWindow): void {
    this.add(window);
    const entry = this.windows.get(window.id)!;
    if (!this.restored.has(window.id) && this.activeSpace(this.spaceOf(entry).output) === this.spaceOf(entry)) this.focus(window.id);
    this.layout(false);
  }

  firstCommit(window: WaylandWindow): void {
    this.add(window);
    const entry = this.windows.get(window.id)!;
    if (entry.floating && !window.isResizable() && window.rect.width > 50 && window.rect.height > 50)
      entry.floatingRect = this.centered(this.spaceOf(entry).output, window.rect.width, window.rect.height);
    if (!this.restored.has(window.id) && this.activeSpace(this.spaceOf(entry).output) === this.spaceOf(entry)) this.focus(window.id);
    this.layout(false);
    if (!this.restored.has(window.id))
      window.animation.start(LIFECYCLE, { from: -1, to: 0, duration: OPEN_MS, easing: easeOutExpo });
  }

  close(window: WaylandWindow, final: boolean): void {
    const entry = this.windows.get(window.id);
    if (!entry) return;
    if (!entry.closing) {
      entry.closing = true;
      const space = this.spaceOf(entry);
      removeWindow(space, this.area(space.output), this.full(space.output), window.id);
      this.mru = this.mru.filter(id => id !== window.id);
      if (!final) {
        window.setCloseAnimationDuration(CLOSE_MS);
        window.animation.start(LIFECYCLE, { from: 0, to: 1, duration: CLOSE_MS, easing: easeOutQuad });
      }
      if (this.focusedId === window.id) {
        this.focusedId = undefined;
        if (this.activeSpace(space.output) === space) this.focus(this.activeWindow(space));
      }
    }
    if (final) {
      entry.dispose.forEach(dispose => dispose());
      this.windows.delete(window.id);
      this.restored.delete(window.id);
      this.stack.delete(window.id);
      this.switching.delete(window.id);
    }
    this.layout();
  }

  focus(id?: string): void {
    const entry = id ? this.windows.get(id) : undefined;
    if (!entry || entry.closing) return;
    const space = this.spaceOf(entry);
    if (this.activeSpace(space.output) !== space) this.activate(space, false);
    this.currentOutput = space.output;
    if (entry.floating) {
      space.floatingActive = true;
      space.floatingFocus = entry.window.id;
    } else {
      const index = columnIndexOf(space, entry.window.id);
      if (index >= 0) {
        space.floatingActive = false;
        space.columns[index].active = entry.window.id;
        activateColumn(space, this.area(space.output), this.full(space.output), index);
      }
    }
    this.focusedId = entry.window.id;
    if (!this.cycle) this.mru = [entry.window.id, ...this.mru.filter(item => item !== entry.window.id)];
    this.stack.set(entry.window.id, ++this.serial);
    this.layout();
    if (!entry.window.isFocused()) entry.window.focus();
  }

  onFocus(window: WaylandWindow, focused: boolean): void {
    if (!focused || this.grabbing || this.focusedId === window.id) return;
    this.focus(window.id);
  }

  pointer(event: PointerMoveEvent): void {
    if (event.outputName) this.currentOutput = event.outputName;
    if (this.cycle && !event.modifiers.alt) this.endCycle();
    // niri's default top-left hot corner toggles the overview on entry.
    const origin = event.outputName ? this.full(event.outputName) : undefined;
    const corner = !!origin && event.position.x - origin.x < 1 && event.position.y - origin.y < 1;
    if (corner && !this.hotCorner && !this.grabbing) this.toggleOverview();
    this.hotCorner = corner;
    if (this.overviewShown || this.grabbing || event.modifiers.super || event.target.kind !== "window") return;
    const entry = this.windows.get(event.target.windowId);
    if (!entry || entry.closing || entry.window.isFocused()) return;
    const space = this.spaceOf(entry);
    if (this.activeSpace(space.output) !== space) return;
    // focus-follows-mouse max-scroll-amount="0%": only windows that are
    // already fully visible, so focusing never scrolls the view.
    if (!entry.floating && !entry.fullscreen) {
      const rect = entry.window.state[VIEW]().rect;
      const area = this.area(space.output);
      if (rect.x + RING < area.x || rect.x + rect.width - RING > area.x + area.width) return;
    }
    this.focus(entry.window.id);
  }

  // Workspace switches slide the strip of workspaces by output height plus
  // niri's 10% workspace gap, passing through the ones in between.
  private animateSwitch(output: string, spaces: Workspace[], from: number, to: number, still: Set<string>): void {
    const step = this.full(output).height * (1 + WORKSPACE_GAP) * (this.overviewShown ? OVERVIEW_ZOOM : 1);
    const token = ++this.serial;
    for (const [id, entry] of this.windows) {
      if (entry.closing || still.has(id)) continue;
      const position = spaces.indexOf(this.spaceOf(entry));
      if (position < 0) continue;
      if (this.overviewShown) {
        entry.window.scheduleAnimation({ channel: SWITCH, offset: {
          from: { x: 0, y: (to - from) * step }, to: { x: 0, y: 0 },
          duration: WORKSPACE_SWITCH_MS, easing: SPRING_CURVE, mode: "add" } });
        continue;
      }
      if (position < Math.min(from, to) || position > Math.max(from, to)) continue;
      // Windows that are still sliding continue from where they are.
      const moving = this.switching.has(id);
      this.switching.set(id, token);
      entry.window.scheduleAnimation({ channel: SWITCH, offset: {
        ...(moving ? {} : { from: { x: 0, y: (position - from) * step } }),
        to: { x: 0, y: (position - to) * step },
        duration: WORKSPACE_SWITCH_MS, easing: SPRING_CURVE, mode: "add" } });
    }
    this.later(WORKSPACE_SWITCH_MS, () => {
      for (const [id, owner] of this.switching) {
        if (owner !== token) continue;
        this.switching.delete(id);
        this.windows.get(id)?.window.cancelAnimation(SWITCH);
      }
      this.layout(false);
    });
  }

  activate(target: Workspace, focusWindow = true, still = new Set<string>()): void {
    const output = target.output;
    const spaces = this.list(output);
    const from = spaces.indexOf(this.activeSpace(output));
    const to = spaces.indexOf(target);
    if (to < 0) return;
    this.currentOutput = output;
    if (from !== to) {
      this.active.set(output, target.id);
      this.animateSwitch(output, spaces, from, to, still);
    }
    if (!focusWindow) return;
    this.focusedId = undefined;
    const id = this.activeWindow(target);
    if (id) this.focus(id);
    else this.layout();
  }
  focusWorkspace(index: number): void {
    const spaces = this.list(this.output());
    this.activate(spaces[Math.min(index, spaces.length) - 1]);
  }
  switchWorkspace(direction: -1 | 1): void {
    const output = this.output();
    const spaces = this.list(output);
    const next = spaces[spaces.indexOf(this.activeSpace(output)) + direction];
    if (next) this.activate(next);
  }

  private moveFloating(entry: Entry, dx: number, dy: number): void {
    entry.floatingRect = { ...entry.floatingRect, x: entry.floatingRect.x + dx, y: entry.floatingRect.y + dy };
    this.layout();
  }
  // niri floating focus_left/right: nearest window centre in that direction.
  private focusFloating(entry: Entry, direction: -1 | 1): void {
    const centre = (rect: Rect) => rect.x + rect.width / 2;
    const from = centre(entry.floatingRect);
    const target = this.spaceOf(entry).floating
      .map(id => this.windows.get(id)!)
      .filter(other => other && other !== entry && (centre(other.floatingRect) - from) * direction > 0)
      .sort((a, b) => Math.abs(centre(a.floatingRect) - from) - Math.abs(centre(b.floatingRect) - from))[0];
    if (target) this.focus(target.window.id);
  }
  focusColumn(direction: -1 | 1): void {
    const entry = this.focused();
    if (entry?.floating) return this.focusFloating(entry, direction);
    const space = entry ? this.spaceOf(entry) : this.activeSpace(this.output());
    const column = space.columns[space.activeColumn + direction];
    if (space.activeColumn >= 0 && column) this.focus(column.active);
  }
  moveColumn(direction: -1 | 1): void {
    const entry = this.focused();
    if (!entry) return;
    if (entry.floating) return this.moveFloating(entry, direction * FLOATING_STEP, 0);
    const space = this.spaceOf(entry);
    const index = space.activeColumn;
    const next = index + direction;
    if (index < 0 || next < 0 || next >= space.columns.length) return;
    const area = this.area(space.output);
    const full = this.full(space.output);
    const current = viewPos(space, area, full);
    [space.columns[index], space.columns[next]] = [space.columns[next], space.columns[index]];
    space.activeColumn = next;
    space.prevOffset = undefined;
    space.viewOffset = fitOffset(space, area, full, next, current);
    this.layout();
  }
  moveVertical(direction: -1 | 1): void {
    const entry = this.focused();
    if (!entry) return;
    if (entry.floating) return this.moveFloating(entry, 0, direction * FLOATING_STEP);
    moveVertical(this.spaceOf(entry), entry.window.id, direction);
    this.layout();
  }
  // niri move-column-to-workspace: the index is clamped to the last
  // (empty) workspace; a floating window moves on its own.
  moveToWorkspace(index: number, follow: boolean): void {
    const entry = this.focused();
    if (!entry) return;
    const source = this.spaceOf(entry);
    const spaces = this.list(source.output);
    const target = spaces[Math.min(index, spaces.length) - 1];
    if (!target || target === source) return;
    const area = this.area(source.output);
    const full = this.full(source.output);
    let ids: string[];
    if (entry.floating) {
      ids = [entry.window.id];
      removeWindow(source, area, full, entry.window.id);
      target.floating.push(entry.window.id);
      if (follow || !target.floatingFocus) target.floatingFocus = entry.window.id;
      if (follow) target.floatingActive = true;
    } else {
      const column = removeColumn(source, area, full, columnIndexOf(source, entry.window.id));
      if (!column) return;
      ids = column.windows;
      const at = target.activeColumn < 0 ? 0 : target.activeColumn + 1;
      target.columns.splice(at, 0, column);
      if (target.activeColumn < 0) {
        target.activeColumn = 0;
        target.viewOffset = fitOffset(target, area, full, 0, 0);
      } else if (follow) activateColumn(target, area, full, at);
      if (follow) target.floatingActive = false;
    }
    for (const id of ids) { const moved = this.windows.get(id); if (moved) moved.workspace = target.id; }
    this.focusedId = undefined;
    if (follow) this.activate(target, true, new Set(ids));
    else this.focus(this.activeWindow(source));
    this.layout();
  }

  private setFloating(entry: Entry, floating: boolean): void {
    if (entry.floating === floating) return;
    const space = this.spaceOf(entry);
    const column = space.columns.find(column => column.windows.includes(entry.window.id));
    if (column) entry.width = column.width;
    removeWindow(space, this.area(space.output), this.full(space.output), entry.window.id);
    entry.floating = floating;
    this.insert(space, entry.window.id, floating, this.focusedId === entry.window.id);
    this.layout();
  }
  toggleFloating(): void {
    const entry = this.focused();
    if (!entry) return;
    entry.manualFloating = !entry.floating;
    this.setFloating(entry, entry.manualFloating);
    this.focus(entry.window.id);
  }
  // set-column-width "80%": a proportion of the working area, which also
  // leaves the full-width state like niri does.
  setColumnWidth(proportion: number): void {
    const entry = this.focused();
    if (!entry) return;
    const space = this.spaceOf(entry);
    const area = this.area(space.output);
    if (entry.floating) {
      const width = Math.min(area.width, area.width * proportion);
      entry.floatingRect = { ...entry.floatingRect, x: entry.floatingRect.x + (entry.floatingRect.width - width) / 2, width };
      return this.layout();
    }
    const index = columnIndexOf(space, entry.window.id);
    const column = space.columns[index];
    if (!column) return;
    column.width = { proportion };
    column.fullWidth = false;
    activateColumn(space, area, this.full(space.output), index);
    this.layout();
  }
  maximizeColumn(): void {
    const entry = this.focused();
    if (!entry || entry.floating) return;
    const space = this.spaceOf(entry);
    const index = columnIndexOf(space, entry.window.id);
    const column = space.columns[index];
    if (!column) return;
    column.fullWidth = !column.fullWidth;
    activateColumn(space, this.area(space.output), this.full(space.output), index);
    this.layout();
  }
  toggleFullscreen(): void {
    const entry = this.focused();
    if (entry) entry.fullscreen ? entry.window.unfullscreen() : entry.window.fullscreen();
  }
  private refit(entry: Entry): void {
    const space = this.spaceOf(entry);
    this.syncModes(space);
    const index = columnIndexOf(space, entry.window.id);
    if (index >= 0 && index === space.activeColumn) activateColumn(space, this.area(space.output), this.full(space.output), index);
  }
  fullscreen(window: WaylandWindow, enabled: boolean): void {
    this.add(window);
    const entry = this.windows.get(window.id)!;
    entry.fullscreen = enabled;
    if (enabled) this.focus(window.id);
    this.refit(entry);
    this.layout();
  }
  // A client maximize request fills the working area without gaps
  // (niri set_maximized).
  maximize(window: WaylandWindow, enabled: boolean): void {
    this.add(window);
    const entry = this.windows.get(window.id)!;
    entry.maximized = enabled;
    this.refit(entry);
    this.layout();
  }
  closeFocused(): void { this.focused()?.window.close(); }

  toggleOverview(open = !this.overviewOpen): void {
    if (open === this.overviewOpen) return;
    this.overviewOpen = open;
    this.overviewShown = true;
    for (const [id, entry] of this.windows) {
      entry.window.animation.start(OVERVIEW, { to: open ? 1 : 0, duration: MOVEMENT_MS, easing: overviewEasing });
      if (this.switching.delete(id)) entry.window.cancelAnimation(SWITCH);
    }
    if (!open) this.later(MOVEMENT_MS, () => {
      if (this.overviewOpen) return;
      this.overviewShown = false;
      this.layout(false);
    });
    this.layout(false);
  }
  selectPreview(id: string): void {
    this.toggleOverview(false);
    this.focus(id);
  }

  // Alt+Tab / Alt+grave from niri's recent-windows defaults.
  mruStep(direction: -1 | 1, sameApp: boolean): void {
    if (!this.cycle) {
      const app = this.focused()?.window.appId();
      const list = this.mru.filter(id => {
        const entry = this.windows.get(id);
        return entry && !entry.closing && (!sameApp || entry.window.appId() === app);
      });
      if (list.length < 2) return;
      this.cycle = { list, index: 0, timer: setTimeout(() => this.endCycle(), MRU_COMMIT_MS) };
    }
    const cycle = this.cycle;
    clearTimeout(cycle.timer);
    cycle.timer = setTimeout(() => this.endCycle(), MRU_COMMIT_MS);
    cycle.index = (cycle.index + direction + cycle.list.length) % cycle.list.length;
    this.focus(cycle.list[cycle.index]);
  }
  private endCycle(): void {
    if (!this.cycle) return;
    clearTimeout(this.cycle.timer);
    this.cycle = undefined;
    const id = this.focusedId;
    if (id) this.mru = [id, ...this.mru.filter(item => item !== id)];
  }

  resize(event: WindowResizeEvent): void {
    const entry = this.windows.get(event.window.id);
    if (!entry || entry.fullscreen) return;
    this.grabbing = event.phase === "start" || event.phase === "update";
    if (entry.floating) entry.floatingRect = shrink(event.currentRect);
    else {
      // niri interactive resize leaves the column with a fixed width.
      const space = this.spaceOf(entry);
      const column = space.columns.find(column => column.windows.includes(event.window.id));
      if (column) {
        column.width = { fixed: Math.max(1, event.currentRect.width - RING * 2) };
        column.fullWidth = false;
      }
    }
    this.layout(false);
  }
  move(event: WindowMoveEvent): void {
    const entry = this.windows.get(event.window.id);
    if (!entry || entry.fullscreen) return;
    this.grabbing = event.phase === "start" || event.phase === "update";
    if (entry.floating) {
      entry.floatingRect = shrink(event.currentRect);
      const space = this.spaceOf(entry);
      if (event.phase === "end" && event.outputName && event.outputName !== space.output) {
        removeWindow(space, this.area(space.output), this.full(space.output), entry.window.id);
        const target = this.activeSpace(event.outputName);
        entry.workspace = target.id;
        this.insert(target, entry.window.id, true, true);
        this.focus(entry.window.id);
      }
      this.layout(false);
      return;
    }
    if (event.phase !== "end") return;
    const space = this.spaceOf(entry);
    const area = this.area(space.output);
    const full = this.full(space.output);
    const rects = tileRects(space, area, full, id => !!this.windows.get(id) && !this.windows.get(id)!.closing);
    const destination = [...rects].find(([id, rect]) => id !== entry.window.id &&
      event.currentPointer.x >= rect.x && event.currentPointer.x <= rect.x + rect.width &&
      event.currentPointer.y >= rect.y && event.currentPointer.y <= rect.y + rect.height);
    if (!destination) { this.layout(); return; }
    const [id, rect] = destination;
    const fraction = (event.currentPointer.y - rect.y) / rect.height;
    if (fraction < 0.25 || fraction > 0.75) {
      // Upper/lower quarter: stack into that column.
      removeWindow(space, area, full, entry.window.id);
      const column = space.columns.find(column => column.windows.includes(id))!;
      column.windows.splice(column.windows.indexOf(id) + (fraction > 0.75 ? 1 : 0), 0, entry.window.id);
    } else {
      // Centre: place the dragged column before the destination column.
      const source = space.columns[columnIndexOf(space, entry.window.id)];
      const target = space.columns[columnIndexOf(space, id)];
      if (source.windows.length > 1) {
        removeWindow(space, area, full, entry.window.id);
        space.columns.splice(space.columns.indexOf(target), 0,
          { windows: [entry.window.id], active: entry.window.id, width: source.width, fullWidth: false, mode: "normal" });
      } else {
        space.columns.splice(space.columns.indexOf(source), 1);
        space.columns.splice(space.columns.indexOf(target), 0, source);
      }
      space.activeColumn = columnIndexOf(space, this.focusedId ?? "");
    }
    this.focus(entry.window.id);
  }

  outputsChanged(): void {
    const live = COMPOSITOR.output.list;
    if (!live.length) return;
    const fallback = this.output();
    const adopt = (space: Workspace, output: string) => {
      const ids = this.order.get(output) ?? [];
      this.order.set(output, ids);
      const before = this.full(space.output);
      space.output = output;
      // Insert before the trailing empty workspace.
      const last = this.spaces.get(ids[ids.length - 1] ?? "");
      ids.splice(last && isEmpty(last) ? ids.length - 1 : ids.length, 0, space.id);
      const after = this.full(output);
      for (const id of space.floating) {
        const entry = this.windows.get(id) ?? this.restored.get(id);
        if (!entry) continue;
        const rect = entry.floatingRect;
        const centre = { x: rect.x + rect.width / 2, y: rect.y + rect.height / 2 };
        const inside = (r: Rect) => centre.x >= r.x && centre.x < r.x + r.width && centre.y >= r.y && centre.y < r.y + r.height;
        if (inside(before) && !inside(after)) entry.floatingRect = { ...rect, x: rect.x - before.x + after.x, y: rect.y - before.y + after.y };
        if (!inside(after)) entry.floatingRect = this.centered(output, rect.width, rect.height);
      }
    };
    // niri moves workspaces of a disconnected output to another output and
    // back again when the original output returns.
    for (const [output, ids] of [...this.order]) {
      if (live.includes(output)) continue;
      this.order.delete(output);
      this.active.delete(output);
      for (const id of ids) {
        const space = this.spaces.get(id);
        if (!space) continue;
        if (isEmpty(space)) this.spaces.delete(id);
        else adopt(space, fallback);
      }
    }
    for (const output of live) {
      for (const [other, ids] of [...this.order]) {
        if (other === output) continue;
        for (const id of [...ids]) {
          const space = this.spaces.get(id);
          if (!space || space.original !== output) continue;
          ids.splice(ids.indexOf(id), 1);
          adopt(space, output);
        }
      }
    }
    const focused = this.focused() ?? (this.focusedId ? this.restored.get(this.focusedId) : undefined);
    const space = focused && this.spaces.get(focused.workspace);
    if (space) this.active.set(space.output, space.id);
    this.layout(false);
  }

  // Three-finger horizontal swipe: niri moves the view by the working-area
  // width per 1200 touchpad units and snaps to a column edge on release.
  scrollGesture(phase: "update" | "end", delta: number, velocity: number): void {
    const space = this.activeSpace(this.output());
    if (space.activeColumn < 0) return;
    const area = this.area(space.output);
    const full = this.full(space.output);
    const scale = area.width / VIEW_GESTURE_MOVEMENT;
    if (phase === "update") {
      space.viewOffset -= delta * scale;
      return this.layout(false);
    }
    const projected = viewPos(space, area, full) - velocity * DECELERATION * scale;
    let best: { index: number; pos: number } | undefined;
    space.columns.forEach((column, index) => {
      const x = columnX(space, area, full, index);
      const width = columnWidth(column, area, full);
      const padding = column.mode === "normal" ? Math.min(GAP, Math.max(0, (area.width - width) / 2)) : 0;
      for (const pos of [x - padding, x + width + padding - area.width])
        if (!best || Math.abs(pos - projected) < Math.abs(best.pos - projected)) best = { index, pos };
    });
    if (!best) return;
    space.activeColumn = best.index;
    space.viewOffset = best.pos - columnX(space, area, full, best.index);
    space.prevOffset = undefined;
    space.floatingActive = false;
    this.focus(space.columns[best.index].active);
  }
  // Three-finger vertical swipe: 300 touchpad units per workspace.
  workspaceGesture(total: number, velocity: number): void {
    const steps = Math.round(-(total + velocity * DECELERATION) / WORKSPACE_GESTURE_MOVEMENT);
    const output = this.output();
    const spaces = this.list(output);
    const index = spaces.indexOf(this.activeSpace(output)) + steps;
    if (steps) this.activate(spaces[Math.max(0, Math.min(spaces.length - 1, index))]);
  }
  // Four-finger vertical swipe: up opens the overview, down closes it.
  overviewGesture(total: number, velocity: number): void {
    const progress = (this.overviewOpen ? 1 : 0) - (total + velocity * DECELERATION) / WORKSPACE_GESTURE_MOVEMENT;
    this.toggleOverview(progress > 0.5);
  }

  layout(animate = true): void {
    const now = Date.now();
    const current = this.output();
    for (const output of COMPOSITOR.output.list) {
      this.cleanup(output);
      const area = this.area(output);
      const full = this.full(output);
      const spaces = this.list(output);
      const activeSpace = this.activeSpace(output);
      const activePosition = spaces.indexOf(activeSpace);
      const outputActive = this.activeWindow(activeSpace);
      for (const [position, space] of spaces.entries()) {
        this.syncModes(space);
        const rects = tileRects(space, area, full, id => { const entry = this.windows.get(id); return !!entry && !entry.closing; });
        for (const id of [...space.columns.flatMap(column => column.windows), ...space.floating]) {
          const entry = this.windows.get(id);
          if (!entry || entry.closing) continue;
          const onActive = space === activeSpace;
          let rect: Rect;
          if (entry.fullscreen) rect = full;
          else if (entry.floating && entry.maximized) rect = area;
          else rect = expand(entry.floating ? entry.floatingRect : rects.get(id) ?? shrink(entry.window.state[VIEW]().rect), RING);
          const visible = onActive || this.overviewShown || this.switching.has(id);
          const view: View = {
            rect, visible, active: onActive || this.overviewShown, tiled: !entry.floating, fullscreen: entry.fullscreen,
            ring: onActive && id === outputActive ? (output === current ? "active" : "inactive") : "none",
            overview: this.overviewShown, position: position - activePosition, outputRect: full,
            workspace: space.id, output,
            zIndex: (entry.fullscreen && !this.overviewShown ? 2000000 : entry.floating ? 1000000 : 0) + (this.stack.get(id) ?? 0),
          };
          const previous = entry.window.state[VIEW]();
          entry.window.state[VIEW].set(view);
          // window-movement / window-resize / horizontal-view-movement springs.
          // A retarget starts from the offset that is still on screen.
          const moved = JSON.stringify(previous.rect) !== JSON.stringify(rect);
          if (animate && visible && previous.visible && previous.output === output && moved) {
            const left = entry.motion ? 1 - springCurveAt((now - entry.motion.start) / MOVEMENT_MS) : 0;
            const residual = entry.motion && left > 0 ? entry.motion.delta : zero;
            const delta = {
              x: previous.rect.x - rect.x + residual.x * left, y: previous.rect.y - rect.y + residual.y * left,
              width: previous.rect.width - rect.width + residual.width * left,
              height: previous.rect.height - rect.height + residual.height * left,
            };
            entry.motion = { delta, start: now };
            entry.window.scheduleAnimation({ channel: MOTION, rect: {
              from: delta, to: zero, duration: MOVEMENT_MS, easing: SPRING_CURVE, mode: "add" } });
          } else if (!animate || !visible) {
            entry.motion = undefined;
            entry.window.cancelAnimation(MOTION);
          }
        }
      }
    }
    COMPOSITOR.workspace.reconfigure();
  }

  snapshot(): Snapshot {
    return {
      serial: this.serial, outputs: [...this.order].map(([output, ids]) => [output, [...ids]]),
      spaces: JSON.parse(JSON.stringify([...this.spaces.values()])), active: [...this.active],
      currentOutput: this.currentOutput, focusedId: this.focusedId, mru: [...this.mru],
      placements: [...this.windows].filter(([, entry]) => !entry.closing).map(([id, entry]) => [id, {
        workspace: entry.workspace, floating: entry.floating, manualFloating: entry.manualFloating, width: entry.width,
        floatingRect: entry.floatingRect, fullscreen: entry.fullscreen, maximized: entry.maximized,
      }]),
    };
  }
  restore(snapshot: Snapshot): void {
    this.serial = Math.max(this.serial, snapshot.serial);
    this.spaces = new Map(snapshot.spaces.map(space => [space.id, space]));
    this.order = new Map(snapshot.outputs);
    this.active = new Map(snapshot.active);
    this.currentOutput = snapshot.currentOutput;
    this.focusedId = snapshot.focusedId;
    this.mru = [...snapshot.mru];
    this.restored = new Map(snapshot.placements);
    for (const [id, entry] of this.windows) {
      const saved = this.restored.get(id);
      if (saved && this.spaces.has(saved.workspace)) Object.assign(entry, saved);
      else {
        const space = this.activeSpace(this.output());
        entry.workspace = space.id;
        this.insert(space, id, entry.floating, false);
      }
    }
    // Windows that did not survive the reload leave their columns.
    this.later(2000, () => {
      for (const id of this.restored.keys()) {
        if (this.windows.has(id)) continue;
        for (const space of this.spaces.values()) removeWindow(space, this.area(space.output), this.full(space.output), id);
      }
      this.restored.clear();
      this.layout(false);
    });
    this.outputsChanged();
    const focused = this.focusedId;
    this.focusedId = undefined;
    this.focus(focused);
  }
  dispose(): void {
    for (const timer of this.timers) clearTimeout(timer);
    this.timers.clear();
    if (this.cycle) clearTimeout(this.cycle.timer);
    for (const entry of this.windows.values()) {
      entry.window.cancelAnimation(SWITCH);
      entry.window.cancelAnimation(MOTION);
      entry.dispose.forEach(dispose => dispose());
    }
  }
}
