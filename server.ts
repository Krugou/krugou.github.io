/* eslint-disable no-console */
import express, { Request, Response } from 'express';
import next from 'next';
import admin from 'firebase-admin';
import fs from 'fs';
import https from 'https';
import path from 'path';

const dev = process.env.NODE_ENV !== 'production';
const useHttps = process.argv.includes('--https');
const app = next({ dev });
const handle = app.getRequestHandler();

// ─── SSL Certificate Paths ───────────────────────────────────────────
const CERT_DIR = path.join(process.cwd(), 'certs');
const CERT_KEY = path.join(CERT_DIR, 'localhost-key.pem');
const CERT_FILE = path.join(CERT_DIR, 'localhost.pem');

// initialize Firebase admin with credentials passed via environment
const initFirebase = () => {
  if (admin.apps.length) {
    return;
  }

  // try service account JSON string first
  let serviceAccount: Record<string, unknown> | undefined;
  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    try {
      serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    } catch {
      console.error('FIREBASE_SERVICE_ACCOUNT is not valid JSON');
    }
  }

  // fallback to path
  const credPath = process.env.FIREBASE_CREDENTIALS_PATH;
  if (!serviceAccount && credPath && fs.existsSync(credPath)) {
    // eslint-disable-next-line @typescript-eslint/no-require-imports
    serviceAccount = require(credPath);
  }

  if (serviceAccount) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    console.log('Firebase admin initialized with service account');
  } else {
    // application default credentials, may work on GCP
    admin.initializeApp();
    console.warn('Firebase admin initialized with default credentials');
  }
};

const getDb = () => {
  initFirebase();
  return admin.firestore();
};

app.prepare().then(() => {
  const server = express();

  server.use(express.json());

  // list all events
  server.get('/api/admin/events', async (req: Request, res: Response) => {
    try {
      const db = getDb();
      const events: Record<string, unknown>[] = [];

      const territoryDoc = await db.collection('events').doc('territory_events').get();
      if (territoryDoc.exists) {
        const territoryData = territoryDoc.data() || {};
        for (const [territoryType, evList] of Object.entries(territoryData)) {
          if (Array.isArray(evList)) {
            evList.forEach((e: Record<string, unknown>) => {
              const copy = { ...e, territoryType };
              events.push(copy);
            });
          }
        }
      }

      const milestoneDoc = await db.collection('events').doc('milestone_events').get();
      if (milestoneDoc.exists) {
        const milestoneData = milestoneDoc.data();
        if (milestoneData && Array.isArray(milestoneData.milestones)) {
          milestoneData.milestones.forEach((e: Record<string, unknown>) => {
            events.push({ ...e, territoryType: 'milestone' });
          });
        }
      }

      res.json(events);
    } catch (err: unknown) {
      console.error('Error fetching events', err);
      if (err instanceof Error) {
        res.status(500).json({ error: err.message });
      } else {
        res.status(500).json({ error: 'Unknown error occurred' });
      }
    }
  });

  // add new event
  server.post('/api/admin/events', async (req: Request, res: Response) => {
    const { event, territoryType } = req.body;
    if (!event || !territoryType) {
      return res.status(400).json({ error: 'event and territoryType are required' });
    }
    try {
      const db = getDb();
      if (territoryType === 'milestone') {
        const mileRef = db.collection('events').doc('milestone_events');
        const doc = await mileRef.get();
        const data = doc.exists ? doc.data()! : { milestones: [] };
        data.milestones = data.milestones || [];
        data.milestones.push(event);
        await mileRef.set(data);
      } else {
        const terrRef = db.collection('events').doc('territory_events');
        const doc = await terrRef.get();
        const data = doc.exists ? doc.data()! : {};
        if (!Array.isArray(data[territoryType])) {
          data[territoryType] = [];
        }
        data[territoryType].push(event);
        await terrRef.set(data);
      }
      res.json({ success: true });
    } catch (err: unknown) {
      console.error('Error adding event', err);
      if (err instanceof Error) {
        res.status(500).json({ error: err.message });
      } else {
        res.status(500).json({ error: 'Unknown error occurred' });
      }
    }
  });

  // update existing event
  server.put('/api/admin/events', async (req: Request, res: Response) => {
    const { event, territoryType } = req.body;
    if (!event || !territoryType || !event.id) {
      return res.status(400).json({ error: 'event with id and territoryType are required' });
    }
    try {
      const db = getDb();
      await removeEvent(db, event.id, territoryType);
      if (territoryType === 'milestone') {
        const mileRef = db.collection('events').doc('milestone_events');
        const doc = await mileRef.get();
        const data = doc.exists ? doc.data()! : { milestones: [] };
        data.milestones = data.milestones || [];
        data.milestones.push(event);
        await mileRef.set(data);
      } else {
        const terrRef = db.collection('events').doc('territory_events');
        const doc = await terrRef.get();
        const data = doc.exists ? doc.data()! : {};
        if (!Array.isArray(data[territoryType])) {
          data[territoryType] = [];
        }
        data[territoryType].push(event);
        await terrRef.set(data);
      }
      res.json({ success: true });
    } catch (err: unknown) {
      console.error('Error updating event', err);
      if (err instanceof Error) {
        res.status(500).json({ error: err.message });
      } else {
        res.status(500).json({ error: 'Unknown error occurred' });
      }
    }
  });

  // delete event
  server.delete('/api/admin/events', async (req: Request, res: Response) => {
    const { eventId, territoryType } = req.body;
    if (!eventId || !territoryType) {
      return res.status(400).json({ error: 'eventId and territoryType are required' });
    }
    try {
      const db = getDb();
      await removeEvent(db, eventId, territoryType);
      res.json({ success: true });
    } catch (err: unknown) {
      console.error('Error deleting event', err);
      if (err instanceof Error) {
        res.status(500).json({ error: err.message });
      } else {
        res.status(500).json({ error: 'Unknown error occurred' });
      }
    }
  });

  // helper for remove
  const removeEvent = async (db: admin.firestore.Firestore, id: string, territoryType: string) => {
    if (territoryType === 'milestone') {
      const mileRef = db.collection('events').doc('milestone_events');
      const doc = await mileRef.get();
      const data = doc.exists ? doc.data()! : { milestones: [] };
      data.milestones = (data.milestones || []).filter((e: Record<string, unknown>) => e.id !== id);
      await mileRef.set(data);
    } else {
      const terrRef = db.collection('events').doc('territory_events');
      const doc = await terrRef.get();
      const data = doc.exists ? doc.data()! : {};
      if (Array.isArray(data[territoryType])) {
        data[territoryType] = data[territoryType].filter(
          (e: Record<string, unknown>) => e.id !== id,
        );
        await terrRef.set(data);
      }
    }
  };

  // everything else handled by Next
  server.all('*', (req: Request, res: Response) => handle(req, res));

  const port = Number(process.env.PORT ?? 3000);
  const httpsPort = Number(process.env.HTTPS_PORT ?? 3443);

  // ─── Start HTTP server ──────────────────────────────────────────────
  if (!useHttps) {
    server.listen(port, () => {
      console.log(`\n  🚀 HTTP server ready`);
      console.log(`     Local:   http://localhost:${port}`);
      console.log(`     Tip:     run  npm run dev:https  for HTTPS\n`);
    });
  }

  // ─── Start HTTPS server (when certs exist) ──────────────────────────
  if (useHttps || (fs.existsSync(CERT_KEY) && fs.existsSync(CERT_FILE))) {
    if (!fs.existsSync(CERT_KEY) || !fs.existsSync(CERT_FILE)) {
      console.error(
        `\n  ⚠️  HTTPS requested but certificates not found.` +
          `\n     Run:  npm run certs:generate\n`,
      );
    } else {
      const sslOptions = {
        key: fs.readFileSync(CERT_KEY),
        cert: fs.readFileSync(CERT_FILE),
      };
      https.createServer(sslOptions, server).listen(httpsPort, () => {
        console.log(`\n  🔒 HTTPS server ready`);
        console.log(`     Local:   https://localhost:${httpsPort}\n`);
      });
    }
  }
});
