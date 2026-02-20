/* eslint-disable func-style, @typescript-eslint/no-unused-vars, no-console */
import { NextRequest, NextResponse } from 'next/server';
import admin from 'firebase-admin';
import fs from 'fs';

// replicate firebase init logic from server.ts
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
    // eslint-disable-next-line @typescript-eslint/no-require-imports
    serviceAccount = require(credPath);
  }
  if (serviceAccount) {
    admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
  } else {
    admin.initializeApp();
  }
};

const getDb = () => {
  initFirebase();
  return admin.firestore();
};

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
      data[territoryType] = data[territoryType].filter((e: Record<string, unknown>) => e.id !== id);
      await terrRef.set(data);
    }
  }
};

export async function GET(req: NextRequest) {
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

    return NextResponse.json(events);
  } catch (err) {
    console.error('Error fetching events', err);
    return NextResponse.json({ error: (err as Error).message }, { status: 500 });
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { event, territoryType } = body;
    if (!event || !territoryType) {
      return NextResponse.json({ error: 'event and territoryType are required' }, { status: 400 });
    }
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
    return NextResponse.json({ success: true });
  } catch (err) {
    console.error('Error adding event', err);
    return NextResponse.json({ error: (err as Error).message }, { status: 500 });
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json();
    const { event, territoryType } = body;
    if (!event || !territoryType || !event.id) {
      return NextResponse.json(
        { error: 'event with id and territoryType are required' },
        { status: 400 },
      );
    }
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
    return NextResponse.json({ success: true });
  } catch (err) {
    console.error('Error updating event', err);
    return NextResponse.json({ error: (err as Error).message }, { status: 500 });
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const body = await req.json();
    const { eventId, territoryType } = body;
    if (!eventId || !territoryType) {
      return NextResponse.json(
        { error: 'eventId and territoryType are required' },
        { status: 400 },
      );
    }
    const db = getDb();
    await removeEvent(db, eventId, territoryType);
    return NextResponse.json({ success: true });
  } catch (err) {
    console.error('Error deleting event', err);
    return NextResponse.json({ error: (err as Error).message }, { status: 500 });
  }
}
