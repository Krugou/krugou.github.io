import { Router } from 'express';
import type { Request, Response } from 'express';
import { getDb } from '../firebase.js';

const router = Router();

/**
 * GET /api/admin/config
 * Retrieves the system configuration (metadata) from Firestore.
 */
router.get('/', async (_req: Request, res: Response) => {
  try {
    const db = getDb();
    const configDoc = await db.collection('config').doc('metadata').get();

    if (!configDoc.exists) {
      // Return default values if doc doesn't exist yet
      return res.json({
        territoryTypes: [
          'rural', 'suburbs', 'urban', 'metropolis', 'border', 'coastal',
          'caves', 'underground', 'mountains', 'desert', 'arctic', 'moon',
          'orbital', 'spaceStation', 'interstellar', 'milestone'
        ],
        eventTypes: ['immigration', 'emigration', 'disaster', 'opportunity', 'milestone'],
        categories: ['opportunity', 'disaster', 'milestone', 'neutral']
      });
    }

    res.json(configDoc.data());
  } catch (err: unknown) {
    console.error('Error fetching config', err);
    res.status(500).json({ error: err instanceof Error ? err.message : 'Unknown error' });
  }
});

/**
 * POST /api/admin/config
 * Updates the system configuration in Firestore.
 */
router.post('/', async (req: Request, res: Response) => {
  try {
    const { territoryTypes, eventTypes, categories } = req.body;
    const db = getDb();

    await db.collection('config').doc('metadata').set({
      territoryTypes,
      eventTypes,
      categories,
      updatedAt: Date.now()
    });

    res.json({ success: true });
  } catch (err: unknown) {
    console.error('Error updating config', err);
    res.status(500).json({ error: err instanceof Error ? err.message : 'Unknown error' });
  }
});

export default router;
