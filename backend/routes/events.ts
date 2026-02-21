import { Router } from 'express';
import type { Request, Response } from 'express';
import { getDb } from '../firebase.ts';
import os from 'os';

const router = Router();

/** Auto-populate metadata on every event save. Existing values are preserved. */
const enrichEvent = (event: Record<string, unknown>, req: Request) => {
  const now = Date.now();
  return {
    // ── defaults (overridden if caller provides them) ──
    probability: 0.5,
    category: 'opportunity',
    timestamp: now,
    // ── caller-provided fields win ──
    ...event,
    // ── server-managed fields (always set) ──
    createdAt: event.createdAt ?? now,
    updatedAt: now,
    createdBy: event.createdBy ?? os.hostname(),
    source: event.source ?? (req.get('User-Agent') || 'unknown'),
  };
};

const removeEvent = async (db: any, id: string, territoryType: string) => {
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

router.get('/', async (_req: Request, res: Response) => {
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
    res.status(500).json({ error: err instanceof Error ? err.message : 'Unknown error occurred' });
  }
});

router.post('/', async (req: Request, res: Response) => {
  const { event, territoryType } = req.body;
  if (!event || !territoryType)
    return res.status(400).json({ error: 'event and territoryType are required' });

  const enriched = enrichEvent(event, req);

  try {
    const db = getDb();
    if (territoryType === 'milestone') {
      const mileRef = db.collection('events').doc('milestone_events');
      const doc = await mileRef.get();
      const data = doc.exists ? doc.data()! : { milestones: [] };
      data.milestones = data.milestones || [];
      data.milestones.push(enriched);
      await mileRef.set(data);
    } else {
      const terrRef = db.collection('events').doc('territory_events');
      const doc = await terrRef.get();
      const data = doc.exists ? doc.data()! : {};
      if (!Array.isArray(data[territoryType])) data[territoryType] = [];
      data[territoryType].push(enriched);
      await terrRef.set(data);
    }

    res.json({ success: true });
  } catch (err: unknown) {
    console.error('Error adding event', err);
    res.status(500).json({ error: err instanceof Error ? err.message : 'Unknown error occurred' });
  }
});

router.put('/', async (req: Request, res: Response) => {
  const { event, territoryType } = req.body;
  if (!event || !territoryType || !event.id)
    return res.status(400).json({ error: 'event with id and territoryType are required' });

  const enriched = enrichEvent(event, req);

  try {
    const db = getDb();
    await removeEvent(db, event.id, territoryType);

    if (territoryType === 'milestone') {
      const mileRef = db.collection('events').doc('milestone_events');
      const doc = await mileRef.get();
      const data = doc.exists ? doc.data()! : { milestones: [] };
      data.milestones = data.milestones || [];
      data.milestones.push(enriched);
      await mileRef.set(data);
    } else {
      const terrRef = db.collection('events').doc('territory_events');
      const doc = await terrRef.get();
      const data = doc.exists ? doc.data()! : {};
      if (!Array.isArray(data[territoryType])) data[territoryType] = [];
      data[territoryType].push(enriched);
      await terrRef.set(data);
    }

    res.json({ success: true });
  } catch (err: unknown) {
    console.error('Error updating event', err);
    res.status(500).json({ error: err instanceof Error ? err.message : 'Unknown error occurred' });
  }
});

router.delete('/', async (req: Request, res: Response) => {
  const { eventId, territoryType } = req.body;
  if (!eventId || !territoryType)
    return res.status(400).json({ error: 'eventId and territoryType are required' });

  try {
    const db = getDb();
    await removeEvent(db, eventId, territoryType);
    res.json({ success: true });
  } catch (err: unknown) {
    console.error('Error deleting event', err);
    res.status(500).json({ error: err instanceof Error ? err.message : 'Unknown error occurred' });
  }
});

export default router;
