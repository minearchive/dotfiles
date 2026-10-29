import { animationVariable } from "shoji_wm";

// niri's built-in animation defaults (niri-config/src/animations.rs); the
// pastel niri config left `animations {}` empty, so these are what it used.
//
// Springs are critically damped (damping-ratio 1) and niri stops them after
// -ln(epsilon) / sqrt(stiffness) seconds (src/animation/spring.rs).
const springMs = (stiffness: number) => Math.round(-Math.log(1e-4) / Math.sqrt(stiffness) * 1000);
const spring = (stiffness: number) => {
  const omegaT = Math.sqrt(stiffness) * springMs(stiffness) / 1000;
  return (t: number) => t >= 1 ? 1 : 1 - (1 + omegaT * t) * Math.exp(-omegaT * t);
};
export const WORKSPACE_SWITCH_MS = springMs(1000);
// horizontal-view-movement, window-movement, window-resize and overview-open-close.
export const MOVEMENT_MS = springMs(800);
export const overviewEasing = spring(800);
// The Rust animator only takes Bézier curves; this fits the normalized
// critically damped spring 1 - (1 + ωt)e^(-ωt) within 2.2%.
export const SPRING_CURVE = { kind: "cubicBezier", x1: 0.289, y1: 0.48, x2: 0.031, y2: 1 } as const;
// Samples SPRING_CURVE the way the Rust animator does, so a retargeted
// animation can start from the position currently on screen.
export function springCurveAt(progress: number): number {
  if (progress <= 0) return 0;
  if (progress >= 1) return 1;
  const { x1, y1, x2, y2 } = SPRING_CURVE;
  const cx = 3 * x1, bx = 3 * (x2 - x1) - cx, ax = 1 - cx - bx;
  const cy = 3 * y1, by = 3 * (y2 - y1) - cy, ay = 1 - cy - by;
  let t = progress;
  for (let i = 0; i < 8; i++) {
    const error = ((ax * t + bx) * t + cx) * t - progress;
    const slope = (3 * ax * t + 2 * bx) * t + cx;
    if (Math.abs(error) < 1e-6 || Math.abs(slope) < 1e-6) break;
    t = Math.min(1, Math.max(0, t - error / slope));
  }
  return ((ay * t + by) * t + cy) * t;
}

// window-open: 150ms ease-out-expo, alpha 0→1 and scale 0.5→1 around the centre.
// window-close: 150ms ease-out-quad, alpha 1→0 and scale 1→0.8.
export const OPEN_MS = 150;
export const CLOSE_MS = 150;
export const easeOutExpo = (t: number) => t >= 1 ? 1 : 1 - 2 ** (-10 * t);
export const easeOutQuad = (t: number) => 1 - (1 - t) ** 2;

// -1..0 while opening, 0..1 while closing; 0 is the resting state, which is
// also the value a window gets after a hot reload.
export const LIFECYCLE = animationVariable("pastel.lifecycle");
export const lifecycleScale = (v: number) => v < 0 ? 1 + v / 2 : 1 - v / 5;
export const lifecycleOpacity = (v: number) => 1 - Math.abs(v);
// 0 = normal view, 1 = overview.
export const OVERVIEW = animationVariable("pastel.overview");
