/* eslint-disable */

import admin from 'firebase-admin';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const LOCAL_SERVICE_ACCOUNT = path.join(
  __dirname,
  '..',
  'backend',
  'immigrants-game-firebase-adminsdk-fbsvc-da4aa4541e.json',
);

function loadServiceAccount(): any {
  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    try {
      return JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT as string);
    } catch (e) {
      console.error('FIREBASE_SERVICE_ACCOUNT is not valid JSON');
    }
  }

  if (process.env.FIREBASE_CREDENTIALS_PATH) {
    const p = process.env.FIREBASE_CREDENTIALS_PATH;
    if (fs.existsSync(p)) {
      try {
        return JSON.parse(fs.readFileSync(p, 'utf8'));
      } catch (e) {
        console.error('FIREBASE_CREDENTIALS_PATH does not point to valid JSON');
      }
    }
  }

  if (fs.existsSync(LOCAL_SERVICE_ACCOUNT)) {
    try {
      return JSON.parse(fs.readFileSync(LOCAL_SERVICE_ACCOUNT, 'utf8'));
    } catch (e) {
      console.error('Local service account file is not valid JSON');
    }
  }

  throw new Error('No Firebase service account configured (set FIREBASE_SERVICE_ACCOUNT secret)');
}

function sanitize(obj: unknown): unknown {
  return JSON.parse(
    JSON.stringify(obj, (k, v) => {
      if (v && typeof (v as any).toDate === 'function') return (v as any).toDate().toISOString();
      return v;
    }),
  );
}

const writeJson = (targetPath: string, data: unknown): void => {
  fs.mkdirSync(path.dirname(targetPath), { recursive: true });
  fs.writeFileSync(targetPath, JSON.stringify(data, null, 2) + '\n', 'utf8');
};

const run = async (): Promise<void> => {
  const serviceAccount = loadServiceAccount();
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
  const db = admin.firestore();

  // Territory events
  const terrDoc = await db.collection('events').doc('territory_events').get();
  const terrData = terrDoc.exists ? terrDoc.data() : {};
  const terrOut = sanitize(terrData);

  // Milestone events
  const mileDoc = await db.collection('events').doc('milestone_events').get();
  const mileData = mileDoc.exists ? mileDoc.data() : { milestones: [] };
  const mileOut = sanitize(mileData);

  const terrPath = path.join(__dirname, '..', 'src', 'data', 'events', 'territory_events.json');
  const milePath = path.join(__dirname, '..', 'src', 'data', 'events', 'milestone_events.json');

  writeJson(terrPath, terrOut);
  writeJson(milePath, mileOut);

  console.log(`Wrote territory events -> ${terrPath}`);
  console.log(`Wrote milestone events -> ${milePath}`);
  process.exit(0);
};

run().catch((err) => {
  console.error('Failed to fetch game data:', err);
  process.exit(1);
});
