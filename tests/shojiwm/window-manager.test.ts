import assert from "node:assert/strict";
import { ScrollingWindowManager, VIEW } from "../../pastel/programs/shojiwm/window-manager";
import { overviewTransform, tileRects, newWorkspace, type Workspace } from "../../pastel/programs/shojiwm/layout";
import { springCurveAt } from "../../pastel/programs/shojiwm/animation";
import { TestWindow, outputs } from "./sdk";

const area = { x: 1920, y: 0, width: 1280, height: 1024 };
const space: Workspace = { ...newWorkspace("t", "DVI-D-1"), activeColumn: 0, columns: [
  { windows: ["a", "b"], active: "a", width: { proportion: 0.5 }, fullWidth: false, mode: "normal" },
  { windows: ["c"], active: "c", width: { proportion: 0.5 }, fullWidth: false, mode: "normal" },
] };
const rects = tileRects(space, area, area, () => true);
assert.equal(rects.get("a")!.x, 1930, "output origin is retained");
assert.equal(rects.get("a")!.width, (1280 - 10) / 2 - 10, "niri proportion: (W - gap) * p - gap");
assert.equal(rects.get("c")!.x + rects.get("c")!.width, 1920 + 1280 - 10, "two halves fill the output exactly");
assert.equal(rects.get("a")!.height, (1024 - 30) / 2, "stacked rows reserve all gaps");
const zoomed = overviewTransform(area, area, 1, 1);
assert.equal(zoomed.scale, 0.5);
assert.equal(area.y + zoomed.translateY, 1024 / 4 + 1024 * 1.1 / 2, "overview stacks workspaces with a 10% gap");
assert.ok(Math.abs(springCurveAt(0.25) - 0.67) < 0.03, "spring curve tracks niri's critically damped spring");

const managed = (window: TestWindow) => window.state[VIEW]().rect;
const client = (window: TestWindow) => { const rect = managed(window); return { x: rect.x + 1, width: rect.width - 2 }; };
const open = (wm: ScrollingWindowManager, window: TestWindow) => {
  wm.add(window as any); wm.initialConfigure(window as any); wm.firstCommit(window as any);
};

const wm = new ScrollingWindowManager();
const a = new TestWindow("a");
const b = new TestWindow("b");
const c = new TestWindow("c");
open(wm, a);
assert.deepEqual(client(a), { x: 10, width: 945 }, "first column sits one gap from the left edge");
assert.equal(managed(a).width, 947, "the focus ring is drawn outside the client");
assert.equal(a.state[VIEW]().ring, "active");
open(wm, b);
assert.deepEqual(client(b), { x: 965, width: 945 }, "second half-width column fits on screen");
assert.equal(client(a).x, 10, "a fully visible column does not scroll the view");
open(wm, c);
assert.equal(client(c).x + client(c).width, 1910, "an overflowing new column is right-aligned");
assert.equal(client(b).x, 10);
wm.close(c as any, false);
wm.close(c as any, true);
assert.equal(b.isFocused(), true, "closing a just-opened column returns to the column it was opened from");
assert.equal(client(a).x, 10, "and restores the previous view");
wm.focusColumn(-1);
wm.close(a as any, true);
assert.equal(b.isFocused(), true, "closing the active column focuses the column that slides into its place");
assert.equal(client(b).x, 10);

wm.setColumnWidth(0.8);
assert.equal(client(b).width, (1920 - 10) * 0.8 - 10);
wm.maximizeColumn();
assert.equal(client(b).width, 1900, "maximize-column uses the full working width");
wm.maximizeColumn();
assert.equal(client(b).width, (1920 - 10) * 0.8 - 10, "maximize-column toggles back");

wm.moveToWorkspace(9, false);
assert.equal(b.state[VIEW]().visible, false, "a silent move keeps the current workspace");
assert.equal(b.state[VIEW]().workspace !== "", true);
wm.switchWorkspace(1);
assert.equal(b.state[VIEW]().visible, true, "workspace 9 clamps to the last (empty) workspace, which is now the second");
assert.equal(b.isFocused(), true);
assert.equal(b.state[VIEW]().position, 0, "leaving an empty workspace removes it, like niri");
wm.switchWorkspace(1);
assert.equal(b.state[VIEW]().position, -1, "an empty workspace always follows the last occupied one");
wm.switchWorkspace(1);
assert.equal(b.state[VIEW]().position, -1, "there is nothing past the trailing empty workspace");
wm.focusWorkspace(1);
assert.equal(b.state[VIEW]().position, 0);
assert.ok(b.animations.some(animation => animation.channel === "pastel.workspace"), "workspace switches slide");

wm.toggleFloating();
assert.equal(b.state[VIEW]().tiled, false);
const floatingX = managed(b).x;
wm.moveColumn(1);
assert.equal(managed(b).x, floatingX + 50, "move-column-right moves a floating window by 50px");
b.title.set("Open File");
wm.toggleFloating();
assert.equal(b.state[VIEW]().tiled, true, "manual tiling overrides a floating window rule");

const d = new TestWindow("d");
open(wm, d);
wm.moveToWorkspace(2, false);
wm.toggleOverview();
assert.equal(d.state[VIEW]().visible, true, "the overview shows other workspaces");
assert.equal(d.state[VIEW]().overview, true);
assert.equal(d.variables.get("pastel.overview"), 1);
wm.selectPreview("d");
assert.equal(d.isFocused(), true, "clicking a preview focuses its window");
assert.equal(d.variables.get("pastel.overview"), 0);

assert.equal(b.state[VIEW]().workspace !== d.state[VIEW]().workspace, true);
wm.mruStep(1, false);
assert.equal(b.isFocused(), true, "Alt+Tab focuses the previously used window across workspaces");
assert.equal(b.state[VIEW]().visible, true);

const saved = wm.snapshot();
wm.dispose();
const restored = new ScrollingWindowManager();
for (const window of [b, d]) restored.add(window as any);
restored.restore(saved);
assert.equal(d.state[VIEW]().visible, false, "hot reload preserves workspace membership");
assert.equal(b.state[VIEW]().visible, true);
restored.focus("d");
assert.equal(d.state[VIEW]().visible, true);

const late = new TestWindow("late-metadata");
late.isResizable.set(false);
restored.add(late as any);
assert.equal(late.state[VIEW]().tiled, false);
late.isResizable.set(true);
assert.equal(late.state[VIEW]().tiled, true, "late metadata reclassifies the initial window");
late.appId.set("org.gnome.clocks");
assert.equal(late.state[VIEW]().tiled, false, "app-id floating rules apply when metadata arrives");
assert.equal(managed(late).width, 802, "gnome clocks opens 800px wide");

const hdmi = outputs.get("HDMI-A-1")!;
outputs.delete("HDMI-A-1");
restored.outputsChanged();
assert.equal(late.state[VIEW]().output, "DVI-D-1", "disconnect migrates the workspace to a live output");
assert.ok(managed(late).x >= 1920, "floating windows remain on-screen after disconnect");
outputs.set("HDMI-A-1", hdmi);
restored.outputsChanged();
assert.equal(late.state[VIEW]().output, "HDMI-A-1", "reconnecting moves the workspace back");
restored.dispose();

const stacked = new ScrollingWindowManager();
const e = new TestWindow("e");
const f = new TestWindow("f");
for (const window of [e, f]) open(stacked, window);
const destination = managed(e);
stacked.move({ window: f, phase: "end", currentPointer: { x: destination.x + 20, y: destination.y + 20 } } as any);
assert.equal(managed(e).x, managed(f).x, "dropping on the upper quarter stacks the window into that column");
assert.ok(managed(f).y < managed(e).y);
stacked.moveVertical(1);
assert.ok(managed(f).y > managed(e).y, "move-window-down reorders the stacked window");
stacked.moveToWorkspace(2, true);
assert.equal(e.state[VIEW]().workspace, f.state[VIEW]().workspace, "a follow move transfers the whole column");
assert.equal(e.state[VIEW]().visible, true);
stacked.fullscreen(f as any, true);
assert.equal(managed(f).width, f.state[VIEW]().outputRect.width, "fullscreen covers the whole output");
stacked.fullscreen(f as any, false);
assert.equal(managed(f).x, managed(e).x, "leaving fullscreen restores the column");
stacked.dispose();
console.log("ShojiWM layout and window-manager transitions passed");
process.exit(0);
