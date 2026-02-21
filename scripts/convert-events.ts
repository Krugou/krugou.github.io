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

function ensureTranslation(obj: unknown): unknown {
  if (typeof obj === 'string') {
    return { en: obj, fi: obj };
  }
  if (obj && typeof obj === 'object' && !Array.isArray(obj)) {
    // already translation-like, ensure en/fi exist
    const o = obj as any;
    if (o.en && o.fi) return obj;
  }
  return obj;
}

async function convert() {
  const serviceAccount = loadServiceAccount();
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
  const db = admin.firestore();

  const docs = ['territory_events', 'milestone_events'];
  for (const docName of docs) {
    const ref = db.collection('events').doc(docName);
    const snap = await ref.get();
    if (!snap.exists) {
      console.warn(`document ${docName} not found`);
      continue;
    }
    const data = snap.data();
    if (!data) continue;

    let changed = false;

    // territory events are stored as a map of arrays
    if (docName === 'territory_events') {
      const payload: any = {};
      for (const key of Object.keys(data)) {
        const arr = data[key] as any[];
        payload[key] = arr.map((evt) => {
          const t = { ...evt };
          if (t.title) {
            const newTitle = ensureTranslation(t.title);
            if (newTitle !== t.title) {
              t.title = newTitle;
              changed = true;
            }
          }
          if (t.description) {
            const newDesc = ensureTranslation(t.description);
            if (newDesc !== t.description) {
              t.description = newDesc;
              changed = true;
            }
          }
          return t;
        });
      }
      if (changed) {
        await ref.set(payload);
        console.log(`updated ${docName}`);
      } else {
        console.log(`${docName} already translation-friendly`);
      }
    } else if (docName === 'milestone_events') {
      const payload: any = { milestones: [] };
      const arr = (data as any).milestones || [];
      payload.milestones = arr.map((evt: any) => {
        const t = { ...evt };
        if (t.title) {
          const newTitle = ensureTranslation(t.title);
          if (newTitle !== t.title) {
            t.title = newTitle;
            changed = true;
          }
        }
        if (t.description) {
          const newDesc = ensureTranslation(t.description);
          if (newDesc !== t.description) {
            t.description = newDesc;
            changed = true;
          }
        }
        return t;
      });
      if (changed) {
        await ref.set(payload);
        console.log(`updated ${docName}`);
      } else {
        console.log(`${docName} already translation-friendly`);
      }
    }
  }
  process.exit(0);
}

convert().catch((e) => {
  console.error('conversion failed', e);
  process.exit(1);
});
