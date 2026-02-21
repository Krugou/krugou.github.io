/* eslint-disable no-console */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { initFirebase, getDb } from './firebase.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const OUTPUT_PATH = path.join(__dirname, '..', 'events-export.md');

const run = async () => {
  initFirebase();
  const db = getDb();

  const lines: string[] = ['# Events Export', '', `> Generated: ${new Date().toISOString()}`, ''];

  // ── Territory Events ──────────────────────────────────────────────
  const terrDoc = await db.collection('events').doc('territory_events').get();
  if (terrDoc.exists) {
    const data = terrDoc.data() || {};
    const docUpdated = terrDoc.updateTime?.toDate().toISOString().slice(0, 10) ?? '—';
    lines.push('## Territory Events', '');

    for (const [territoryType, evList] of Object.entries(data)) {
      if (!Array.isArray(evList) || evList.length === 0) continue;

      lines.push(`### ${territoryType}`, '');
      lines.push('| id | title | type | pop Δ | prob | added | createdBy | description |');
      lines.push('|----|-------|------|-------|------|-------|-----------|-------------|');

      for (const ev of evList) {
        const id = ev.id ?? '—';
        const title = typeof ev.title === 'object' ? ev.title.en : (ev.title ?? '—');
        const type = ev.type ?? '—';
        const pop = ev.populationChange ?? 0;
        const prob = ev.probability ?? '—';
        const ts = ev.timestamp ? new Date(ev.timestamp).toISOString().slice(0, 10) : docUpdated;
        const by = ev.createdBy ?? '—';
        const rawDesc = typeof ev.description === 'object' ? ev.description.en : (ev.description ?? '');
        const desc = rawDesc.replace(/\|/g, '\\|').replace(/\n/g, ' ');
        lines.push(
          `| ${id} | ${title} | ${type} | ${pop > 0 ? '+' : ''}${pop} | ${prob} | ${ts} | ${by} | ${desc} |`,
        );
      }
      lines.push('');
    }
  } else {
    lines.push('## Territory Events', '', '_No territory events found._', '');
  }

  // ── Milestone Events ──────────────────────────────────────────────
  const mileDoc = await db.collection('events').doc('milestone_events').get();
  if (mileDoc.exists) {
    const mileData = mileDoc.data();
    const milestones = mileData?.milestones;
    const mileDocUpdated = mileDoc.updateTime?.toDate().toISOString().slice(0, 10) ?? '—';

    lines.push('## Milestone Events', '');

    if (Array.isArray(milestones) && milestones.length > 0) {
      lines.push(
        '| id | title | threshold | type | pop Δ | prob | added | createdBy | description |',
      );
      lines.push(
        '|----|-------|-----------|------|-------|------|-------|-----------|-------------|',
      );

      for (const ev of milestones) {
        const id = ev.id ?? '—';
        const title = typeof ev.title === 'object' ? ev.title.en : (ev.title ?? '—');
        const threshold = ev.threshold ?? '—';
        const type = ev.type ?? '—';
        const pop = ev.populationChange ?? 0;
        const prob = ev.probability ?? '—';
        const ts = ev.timestamp
          ? new Date(ev.timestamp).toISOString().slice(0, 10)
          : mileDocUpdated;
        const by = ev.createdBy ?? '—';
        const rawDesc = typeof ev.description === 'object' ? ev.description.en : (ev.description ?? '');
        const desc = rawDesc.replace(/\|/g, '\\|').replace(/\n/g, ' ');
        lines.push(
          `| ${id} | ${title} | ${threshold} | ${type} | ${pop > 0 ? '+' : ''}${pop} | ${prob} | ${ts} | ${by} | ${desc} |`,
        );
      }
      lines.push('');
    } else {
      lines.push('_No milestone events found._', '');
    }
  } else {
    lines.push('## Milestone Events', '', '_No milestone events found._', '');
  }

  const md = lines.join('\n');
  fs.writeFileSync(OUTPUT_PATH, md, 'utf8');
  console.log(`✅ Exported ${lines.length} lines to ${OUTPUT_PATH}`);
  process.exit(0);
};

run().catch((err) => {
  console.error('Export failed:', err);
  process.exit(1);
});
