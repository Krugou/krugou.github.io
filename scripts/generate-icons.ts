import sharp from 'sharp';
import fs from 'fs';
import path from 'path';

type IconFormat = 'png' | 'ico' | 'jpg';
interface IconSpec {
  name: string;
  size: number;
  format?: IconFormat;
}

async function generateIcons(): Promise<void> {
  const masterIconPath = path.resolve('public/master-icon.png');

  if (!fs.existsSync(masterIconPath)) {
    console.error('Master icon not found at public/master-icon.png');
    process.exit(1);
  }

  const sizes: IconSpec[] = [
    { name: 'icon-192x192.png', size: 192 },
    { name: 'icon-512x512.png', size: 512 },
    { name: 'apple-icon.png', size: 180 },
    { name: 'favicon.ico', size: 32, format: 'ico' },
  ];

  for (const icon of sizes) {
    const outputPath = path.resolve('public', icon.name);
    console.log(`Generating ${icon.name}...`);

    const pipeline = sharp(masterIconPath).resize(icon.size, icon.size, { fit: 'cover' });

    try {
      if (icon.format === 'ico') {
        // Sharp doesn't write multi-image .ico files out of the box. We'll generate a PNG buffer
        // sized appropriately and write it both as .png and as .ico (containing PNG bytes) which
        // works in modern browsers that accept PNG-formatted favicons.
        const pngBuffer = await pipeline.png().toBuffer();
        const pngPath = outputPath.replace(/\.ico$/i, '.png');
        fs.writeFileSync(pngPath, pngBuffer);
        fs.writeFileSync(outputPath, pngBuffer);
      } else {
        // Choose format by extension
        const ext = path.extname(icon.name).toLowerCase();
        if (ext === '.jpg' || ext === '.jpeg') {
          await pipeline.jpeg().toFile(outputPath);
        } else {
          await pipeline.png().toFile(outputPath);
        }
      }
    } catch (err) {
      console.error(`Failed to generate ${icon.name}:`, err);
      throw err;
    }
  }

  console.log('Icons generated successfully!');
}

// Execute when run directly
generateIcons().catch((err) => {
  console.error(err);
  process.exit(1);
});
