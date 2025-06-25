import sharp from 'sharp';
import {Theme, themeFromSourceColor} from "@material/material-color-utilities";
import fs from 'fs';
import quantize, {RgbPixel} from 'quantize';

function registerFile(path: string) {
    fs.watch(path, { persistent: true }, (eventType, filename) => {
        if (eventType == 'change') {
        }
    });
}

async function generateFromImage(path: string): Promise<Theme> {
    const color = await extractDominantColorsFromImage(path, 0);
    if (!color) {
        throw new Error('Failed to extract dominant colors from image');
    }

    return themeFromSourceColor(color[0] << 16 | color[1] << 8 | color[2], []);
}

async function extractDominantColorsFromImage(imagePath: string, colorCount: number = 8): Promise<quantize.RgbPixel> {
    const imageBuffer = fs.readFileSync(imagePath);
    const { data, info } = await sharp(imageBuffer)
        .resize(64, 64, { fit: 'inside' })
        .raw()
        .toBuffer({ resolveWithObject: true });
    const pixels: number[][] = [];
    for (let i = 0; i < data.length; i += info.channels) {
        pixels.push([
            data[i],
            data[i + 1],
            data[i + 2]
        ]);
    }
    const rgbArray: RgbPixel[] = pixels.map(pixel => [pixel[0], pixel[1], pixel[2]] as RgbPixel);
    const colorMap = quantize(rgbArray, colorCount);
    if (!colorMap) {
        throw new Error('Failed to generate color map');
    }

    const palette = colorMap.palette();

    if (palette.length === 0) {
        throw new Error('Palette is empty');
    }

    return palette.at(0) as quantize.RgbPixel;
}
