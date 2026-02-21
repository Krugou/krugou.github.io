/* eslint-disable no-console */
import express from 'express';
import type { Request, Response } from 'express';
import admin from 'firebase-admin';
import fs from 'fs';
import https from 'https';
import path from 'path';

const useHttps = process.argv.includes('--https');

// SSL certificate paths
const CERT_DIR = path.join(process.cwd(), 'certs');
const CERT_KEY = path.join(CERT_DIR, 'localhost-key.pem');
const CERT_FILE = path.join(CERT_DIR, 'localhost.pem');

// Initialize Firebase Admin with credentials from environment.
const initFirebase = () => {
  if (admin.apps.length) {
    return;
  }

  let serviceAccount: Record<string, unknown> | undefined;

  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    try {
      serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    } catch {
      console.error('FIREBASE_SERVICE_ACCOUNT is not valid JSON');
    }
  }

  const credPath = process.env.FIREBASE_CREDENTIALS_PATH;
  if (!serviceAccount && credPath && fs.existsSync(credPath)) {
    try {
      serviceAccount = JSON.parse(fs.readFileSync(credPath, 'utf8')) as Record<string, unknown>;
    } catch {
      console.error('FIREBASE_CREDENTIALS_PATH does not point to valid JSON');
    }
  }

  if (serviceAccount) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    console.log('Firebase admin initialized with service account');
  } else {
    admin.initializeApp();
    console.warn('Firebase admin initialized with default credentials');
  }
};

const getDb = () => {
  initFirebase();
  return admin.firestore();
};

const startServer = () => {
  const server = express();
  server.use(express.json());

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

  server.get('/health', (_req: Request, res: Response) => {
    res.json({ ok: true, service: 'admin-api' });
  });

  server.get('/api/admin/events', async (_req: Request, res: Response) => {
    try {
      const db = getDb();
      const events: Record<string, unknown>[] = [];

      const territoryDoc = await db.collection('events').doc('territory_events').get();
      if (territoryDoc.exists) {
        const territoryData = territoryDoc.data() || {};
        for (const [territoryType, evList] of Object.entries(territoryData)) {
          if (Array.isArray(evList)) {
            evList.forEach((e: Record<string, unknown>) => {
              events.push({ ...e, territoryType });
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
      res
        .status(500)
        .json({ error: err instanceof Error ? err.message : 'Unknown error occurred' });
    }
  });

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

      return res.json({ success: true });
    } catch (err: unknown) {
      console.error('Error adding event', err);
      return res
        .status(500)
        .json({ error: err instanceof Error ? err.message : 'Unknown error occurred' });
    }
  });

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

      return res.json({ success: true });
    } catch (err: unknown) {
      console.error('Error updating event', err);
      return res
        .status(500)
        .json({ error: err instanceof Error ? err.message : 'Unknown error occurred' });
    }
  });

  server.delete('/api/admin/events', async (req: Request, res: Response) => {
    const { eventId, territoryType } = req.body;
    if (!eventId || !territoryType) {
      return res.status(400).json({ error: 'eventId and territoryType are required' });
    }

    try {
      const db = getDb();
      await removeEvent(db, eventId, territoryType);
      return res.json({ success: true });
    } catch (err: unknown) {
      console.error('Error deleting event', err);
      return res
        .status(500)
        .json({ error: err instanceof Error ? err.message : 'Unknown error occurred' });
    }
  });

  const port = Number(process.env.PORT ?? 3000);
  const httpsPort = Number(process.env.HTTPS_PORT ?? 3443);

  if (!useHttps) {
    server.listen(port, () => {
      console.log('\n  API server ready');
      console.log(`     Local:   http://localhost:${port}`);
      console.log('     Health:  /health\n');
    });
  }

  if (useHttps || (fs.existsSync(CERT_KEY) && fs.existsSync(CERT_FILE))) {
    if (!fs.existsSync(CERT_KEY) || !fs.existsSync(CERT_FILE)) {
      console.error(
        '\n  HTTPS requested but certificates not found.\n' + '     Run: npm run certs:generate\n',
      );
    } else {
      const sslOptions = {
        key: fs.readFileSync(CERT_KEY),
        cert: fs.readFileSync(CERT_FILE),
      };

      https.createServer(sslOptions, server).listen(httpsPort, () => {
        console.log('\n  HTTPS API server ready');
        console.log(`     Local:   https://localhost:${httpsPort}`);
        console.log('     Health:  /health\n');
      });
    }
  }
};

import createApp from './app';
import fs from 'fs';
import https from 'https';
import path from 'path';

const useHttps = process.argv.includes('--https');

const CERT_DIR = path.join(process.cwd(), 'certs');
const CERT_KEY = path.join(CERT_DIR, 'localhost-key.pem');
const CERT_FILE = path.join(CERT_DIR, 'localhost.pem');

const startServer = () => {
  const app = createApp();

  const port = Number(process.env.PORT ?? 3000);
  const httpsPort = Number(process.env.HTTPS_PORT ?? 3443);

  if (!useHttps) {
    app.listen(port, () => {
      console.log('\n  API server ready');
      console.log(`     Local:   http://localhost:${port}`);
      console.log('     Health:  /health\n');
    });
  }

  if (useHttps || (fs.existsSync(CERT_KEY) && fs.existsSync(CERT_FILE))) {
    if (!fs.existsSync(CERT_KEY) || !fs.existsSync(CERT_FILE)) {
      console.error(
        '\n  HTTPS requested but certificates not found.\n' + '     Run: npm run certs:generate\n',
      );
    } else {
      const sslOptions = { key: fs.readFileSync(CERT_KEY), cert: fs.readFileSync(CERT_FILE) };
      https.createServer(sslOptions, app).listen(httpsPort, () => {
        console.log('\n  HTTPS API server ready');
        console.log(`     Local:   https://localhost:${httpsPort}`);
        console.log('     Health:  /health\n');
      });
    }
  }
};

startServer();
