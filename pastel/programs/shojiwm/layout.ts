// Geometry follows niri's scrolling layout (src/layout/scrolling.rs) and is
// expressed in output-global logical pixels, as documented by ShojiWM.
export interface Rect { x: number; y: number; width: number; height: number }
export type ColumnWidth = { proportion: number } | { fixed: number };
export type ColumnMode = "normal" | "maximized" | "fullscreen";
export interface Column {
  windows: string[];
  active: string;
  width: ColumnWidth;
  // maximize-column: niri's is_full_width, which keeps `width` for the toggle back.
  fullWidth: boolean;
  mode: ColumnMode;
}
export interface Workspace {
  id: string;
  output: string;
  // niri moves workspaces back to their output when it reconnects.
  original: string;
  columns: Column[];
  floating: string[];
  activeColumn: number;
  floatingActive: boolean;
  floatingFocus?: string;
  // niri's view_offset: view position relative to the active column's x.
  viewOffset: number;
  // niri's activate_prev_column_on_removal: the view offset to restore.
  prevOffset?: number;
}

export const GAP = 10;
// focus-ring width; the ring is drawn outside the window, inside the gap.
export const RING = 1;
export const DEFAULT_WIDTH: ColumnWidth = { proportion: 0.5 };
// niri: workspace gap is 10% of the output height, overview zoom 0.5.
export const WORKSPACE_GAP = 0.1;
export const OVERVIEW_ZOOM = 0.5;

export function newWorkspace(id: string, output: string): Workspace {
  return { id, output, original: output, columns: [], floating: [], activeColumn: -1, floatingActive: false, viewOffset: -GAP };
}

export function isEmpty(space: Workspace): boolean {
  return space.columns.length === 0 && space.floating.length === 0;
}

export function columnWidth(column: Column, area: Rect, full: Rect): number {
  if (column.mode === "fullscreen") return full.width;
  if (column.mode === "maximized") return area.width;
  if (column.fullWidth) return Math.max(1, area.width - GAP * 2);
  if ("fixed" in column.width) return Math.max(1, column.width.fixed);
  return Math.max(1, (area.width - GAP) * column.width.proportion - GAP);
}

export function columnX(space: Workspace, area: Rect, full: Rect, index: number): number {
  let x = 0;
  for (let i = 0; i < index && i < space.columns.length; i++) x += columnWidth(space.columns[i], area, full) + GAP;
  return x;
}

export function viewPos(space: Workspace, area: Rect, full: Rect): number {
  if (space.activeColumn < 0) return 0;
  return columnX(space, area, full, space.activeColumn) + space.viewOffset;
}

// niri compute_new_view_offset: keep a fully visible column in place,
// otherwise align it to whichever edge needs less motion.
export function fitOffset(space: Workspace, area: Rect, full: Rect, index: number, currentPos = viewPos(space, area, full)): number {
  const column = space.columns[index];
  if (!column) return -GAP;
  if (column.mode === "fullscreen") return 0;
  const x = columnX(space, area, full, index);
  const width = columnWidth(column, area, full);
  if (area.width <= width) return 0;
  const gaps = column.mode === "maximized" ? 0 : GAP;
  const padding = Math.min(gaps, Math.max(0, (area.width - width) / 2));
  const left = x - padding;
  const right = x + width + padding;
  if (currentPos <= left && right <= currentPos + area.width) return currentPos - x;
  return Math.abs(currentPos - left) <= Math.abs(currentPos + area.width - right) ? -padding : -(area.width - padding - width);
}

export function activateColumn(space: Workspace, area: Rect, full: Rect, index: number): void {
  if (index < 0 || index >= space.columns.length) return;
  if (index === space.activeColumn) {
    space.viewOffset = fitOffset(space, area, full, index);
    return;
  }
  const current = viewPos(space, area, full);
  space.viewOffset = fitOffset(space, area, full, index, current);
  space.activeColumn = index;
  space.prevOffset = undefined;
}

// Client rects (without the focus ring) for every tiled window.
export function tileRects(space: Workspace, area: Rect, full: Rect, included: (id: string) => boolean): Map<string, Rect> {
  const rects = new Map<string, Rect>();
  let x = area.x - viewPos(space, area, full);
  for (const column of space.columns) {
    const width = columnWidth(column, area, full);
    const windows = column.windows.filter(included);
    const gap = column.mode === "normal" ? GAP : 0;
    const height = Math.max(1, (area.height - gap * (windows.length + 1)) / Math.max(1, windows.length));
    windows.forEach((id, index) => rects.set(id, { x, y: area.y + gap + index * (height + gap), width, height }));
    x += width + GAP;
  }
  return rects;
}

export function columnIndexOf(space: Workspace, id: string): number {
  return space.columns.findIndex(column => column.windows.includes(id));
}

export function moveVertical(space: Workspace, id: string, direction: -1 | 1): void {
  const column = space.columns.find(column => column.windows.includes(id));
  if (!column) return;
  const index = column.windows.indexOf(id);
  const next = index + direction;
  if (next < 0 || next >= column.windows.length) return;
  [column.windows[index], column.windows[next]] = [column.windows[next], column.windows[index]];
}

// niri remove_column_by_idx / Column::remove_tile focus rules.
export function removeWindow(space: Workspace, area: Rect, full: Rect, id: string): void {
  if (space.floating.includes(id)) {
    const index = space.floating.indexOf(id);
    space.floating.splice(index, 1);
    if (space.floatingFocus === id) space.floatingFocus = space.floating[Math.min(index, space.floating.length - 1)];
    if (space.floating.length === 0) space.floatingActive = false;
    return;
  }
  const index = columnIndexOf(space, id);
  if (index < 0) return;
  const column = space.columns[index];
  if (column.windows.length > 1) {
    const tile = column.windows.indexOf(id);
    column.windows.splice(tile, 1);
    if (column.active === id) column.active = column.windows[Math.min(tile, column.windows.length - 1)];
    return;
  }
  removeColumn(space, area, full, index);
}

export function removeColumn(space: Workspace, area: Rect, full: Rect, index: number): Column | undefined {
  const column = space.columns[index];
  if (!column) return undefined;
  const active = space.activeColumn;
  const offset = space.viewOffset;
  space.columns.splice(index, 1);
  if (space.columns.length === 0) {
    space.activeColumn = -1;
    space.viewOffset = -GAP;
    space.prevOffset = undefined;
    return column;
  }
  if (index + 1 === active) space.prevOffset = undefined;
  if (index < active) {
    space.activeColumn = active - 1;
    space.prevOffset = undefined;
  } else if (index === active && space.prevOffset !== undefined) {
    if (index > 0) {
      space.activeColumn = index - 1;
      space.viewOffset = space.prevOffset;
      space.viewOffset = fitOffset(space, area, full, index - 1);
    }
    space.prevOffset = undefined;
  } else if (index === active) {
    const next = Math.min(index, space.columns.length - 1);
    if (next === index) {
      space.activeColumn = next;
      space.viewOffset = offset;
    } else {
      // Fit the left neighbour starting from where the view was.
      const current = columnX(space, area, full, index) + offset;
      space.activeColumn = next;
      space.viewOffset = fitOffset(space, area, full, next, current);
    }
  }
  return column;
}

// Overview: workspaces scaled by `zoom` around the output centre and stacked
// vertically with the active workspace in the middle (niri monitor.rs
// workspaces_render_geo). `position` is the workspace index minus the active one.
export function overviewTransform(rect: Rect, output: Rect, position: number, progress: number) {
  const zoom = 1 - (1 - OVERVIEW_ZOOM) * progress;
  const x = output.x + (rect.x - output.x) * zoom + output.width * (1 - zoom) / 2;
  const step = (output.height + output.height * WORKSPACE_GAP) * zoom;
  const y = output.y + (rect.y - output.y) * zoom + output.height * (1 - zoom) / 2 + position * step;
  return { origin: { x: 0, y: 0 }, scale: zoom, translateX: x - rect.x, translateY: y - rect.y };
}

export function expand(rect: Rect, by: number): Rect {
  return { x: rect.x - by, y: rect.y - by, width: rect.width + by * 2, height: rect.height + by * 2 };
}
