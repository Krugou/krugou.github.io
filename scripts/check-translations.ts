/* eslint-disable func-style, @typescript-eslint/no-explicit-any, no-console */
import fs from 'fs';
import path from 'path';

// Recursively collect keys of an object, using dot notation
function collectKeys(obj: any, prefix = ''): string[] {
  if (typeof obj !== 'object' || obj === null) {
    return [prefix];
  }
  const keys: string[] = [];
  for (const k of Object.keys(obj)) {
    const next = prefix ? `${prefix}.${k}` : k;
    keys.push(...collectKeys(obj[k], next));
  }
  return keys;
}

const localesDir = path.resolve(process.cwd(), 'src', 'locales');
const files = fs.readdirSync(localesDir).filter((f) => f.endsWith('.json'));
const allKeysByFile: Record<string, Set<string>> = {};

for (const file of files) {
  const content = fs.readFileSync(path.join(localesDir, file), 'utf-8');
  try {
    const obj = JSON.parse(content);
    const keys = collectKeys(obj);
    allKeysByFile[file] = new Set(keys);
  } catch (e) {
    console.error(`Error parsing ${file}:`, e);
  }
}

const allKeys = new Set<string>();
for (const s of Object.values(allKeysByFile)) {
  s.forEach((k) => allKeys.add(k));
}

let missingFound = false;
for (const file of files) {
  const fileKeys = allKeysByFile[file] || new Set();
  const missing = [...allKeys].filter((k) => !fileKeys.has(k));
  if (missing.length) {
    missingFound = true;
    console.log(`\nMissing keys in ${file}:`);
    missing.forEach((k) => console.log(`  - ${k}`));
  }
}

if (!missingFound) {
  console.log('All translation files contain the same set of keys.');
  process.exit(0);
} else {
  process.exit(1);
}
