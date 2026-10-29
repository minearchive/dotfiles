// Minimal SDK boundary for exercising window-manager transitions without DRM.
type Signal<T> = (() => T) & { set(value: T): void; subscribe(fn: () => void): () => void };
export function signal<T>(initial: T): Signal<T> {
  let value = initial;
  const listeners = new Set<() => void>();
  const result = (() => value) as Signal<T>;
  result.set = next => { value = next; listeners.forEach(fn => fn()); };
  result.subscribe = fn => { listeners.add(fn); return () => { listeners.delete(fn); }; };
  return result;
}
const defaults = new Map<string, (window: TestWindow) => unknown>();
export function createWindowState(name: string, spec: { default: unknown }) {
  defaults.set(name, typeof spec.default === "function" ? spec.default as (window: TestWindow) => unknown : () => spec.default);
  return name;
}
export const outputs = new Map([
  ["HDMI-A-1", { position: { x: 0, y: 0 }, resolution: { width: 1920, height: 1080 }, scale: 1 }],
  ["DVI-D-1", { position: { x: 1920, y: 0 }, resolution: { width: 1280, height: 1024 }, scale: 1 }],
]);
export function animationVariable(name: string) { return name; }
export const COMPOSITOR = {
  output: { get list() { return [...outputs.keys()]; }, get: (name: string) => outputs.get(name) },
  layer: { usableArea: () => undefined },
  workspace: { configure: () => {}, reconfigure: () => {}, event: { onActivate: () => {} } },
};
const windows = new Set<TestWindow>();
export class TestWindow {
  title = signal("Terminal");
  appId = signal<string | undefined>("kitty");
  parentId = signal<string | undefined>(undefined);
  isTransient = signal(false);
  isResizable = signal(true);
  isFullscreen = signal(false);
  isMaximized = signal(false);
  isFocused = signal(false);
  rect = { x: 0, y: 0, width: 600, height: 400 };
  state: Record<string, Signal<any>>;
  animations: any[] = [];
  variables = new Map<string, number>();
  animation = {
    set: (variable: string, value: number) => { this.variables.set(variable, value); },
    start: (variable: string, options: { to?: number }) => { this.variables.set(variable, options.to ?? 1); },
  };
  constructor(public id: string) {
    const values = new Map<string, Signal<unknown>>();
    this.state = new Proxy({}, { get: (_target, key: string) => {
      if (!values.has(key)) values.set(key, signal(defaults.get(key)!(this)));
      return values.get(key);
    } });
    windows.add(this);
  }
  focus() { windows.forEach(window => window.isFocused.set(window === this)); }
  scheduleAnimation(animation: unknown) { this.animations.push(animation); }
  cancelAnimation() {}
  setCloseAnimationDuration() {}
  fullscreen() {}
  unfullscreen() {}
  close() {}
}
