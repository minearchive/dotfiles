import { themeFromSourceColor } from "https://esm.sh/@material/material-color-utilities";
import { Image } from "https://deno.land/x/imagescript@1.2.15/mod.ts";

export async function registerFile(path) {
  const watcher = Deno.watchFs(path);
  for await (const event of watcher) {
    if (event.kind === "modify") {
      const theme = await generateFromImage(path);
      await writeToCss("/home/" + Deno.env.get("USER") + "/.local/share/ags-bar/_theme.css", theme);
    }
  }
}

export async function generateFromImage(path) {
  const imageData = await Deno.readFile(path);
  const image = await Image.decode(imageData);
  const small = image.resize(256, 144, Image.RESIZE_NEAREST_NEIGHBOR);
  const colorMap = new Map();
  for (let y = 0; y < small.height; y++) {
    for (let x = 0; x < small.width; x++) {
      // Defensive: skip if x or y is out of bounds
      if (x < 0 || x >= small.width || y < 0 || y >= small.height) continue;
      let pixel;
      try {
        pixel = small.getPixelAt(x, y);
      } catch (_) {
        continue;
      }
      if (pixel && pixel.length >= 3) {
        const [r, g, b] = pixel;
        const key = `${r},${g},${b}`;
        colorMap.set(key, (colorMap.get(key) || 0) + 1);
      }
    }
  }
  let max = 0;
  let dominant = [33, 150, 243]; // fallback
  for (const [key, count] of colorMap.entries()) {
    if (count > max) {
      max = count;
      dominant = key.split(",").map(Number);
    }
  }
  return themeFromSourceColor((dominant[0] << 16) | (dominant[1] << 8) | dominant[2], []);
}


async function writeToCss(file, theme) {
  await Deno.writeTextFile(file, themeToCSS(theme));
}

export function themeToCSS(theme) {
  const dark = theme.schemes.dark;
  const cssVars = [
    ["primary", dark.primary],
    ["on-primary", dark.onPrimary],
    ["primary-container", dark.primaryContainer],
    ["on-primary-container", dark.onPrimaryContainer],
    ["secondary", dark.secondary],
    ["on-secondary", dark.onSecondary],
    ["secondary-container", dark.secondaryContainer],
    ["on-secondary-container", dark.onSecondaryContainer],
    ["tertiary", dark.tertiary],
    ["on-tertiary", dark.onTertiary],
    ["tertiary-container", dark.tertiaryContainer],
    ["on-tertiary-container", dark.onTertiaryContainer],
    ["error", dark.error],
    ["on-error", dark.onError],
    ["background", dark.background],
    ["on-background", dark.onBackground],
    ["surface", dark.surface],
    ["on-surface", dark.onSurface],
    ["outline", dark.outline],
  ];
  const toHex = (color) => `#${color.toString(16).padStart(6, "0")}`;
  let css = ":root {\n";
  for (const [name, value] of cssVars) {
    if (typeof value === "number") {
      css += `  --${name}: ${toHex(value)};\n`;
    }
  }
  css += "}\n";
  return css;
}

if (import.meta.main) {
  const args = [...Deno.args];
  let imagePath = null;
  let outCss = null;
  let printTheme = false;

  for (let i = 0; i < args.length; ++i) {
    if (args[i] === "-o" || args[i] === "--out") {
      outCss = args[++i];
    } else if (args[i] === "-p" || args[i] === "--print") {
      printTheme = true;
    } else if (!imagePath) {
      imagePath = args[i];
    }
  }

  if (!imagePath) {
    console.error("Usage: deno run --allow-read[ --allow-write] ColorCalculator.js <image-path> [-o <css-out>] [--print]");
    Deno.exit(1);
  }

  //stopwatch

  console.time("ColorCalculator");

  generateFromImage(imagePath).then(theme => {
    if (printTheme) {
      console.log(theme);
    }
    if (outCss) {
      writeToCss(outCss, theme);
    }
  }).catch(e => {
    console.error(e);
    Deno.exit(1);
  });

  console.timeEnd("ColorCalculator");
}
