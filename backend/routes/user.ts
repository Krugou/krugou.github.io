import { Router } from 'express';
import type { Request, Response } from 'express';
import { getDb } from '../firebase.js';

const router = Router();

// Save user game state
router.post('/save', async (req: Request, res: Response) => {
  const { userId, gameState } = req.body;
  if (!userId || !gameState) {
    return res.status(400).json({ error: 'userId and gameState are required' });
  }

  try {
    const db = getDb();
    await db.collection('users').doc(userId).set({
      gameState,
      updatedAt: Date.now(),
    });
    res.json({ success: true });
  } catch (err: unknown) {
    console.error('Error saving game state', err);
    res.status(500).json({ error: err instanceof Error ? err.message : 'Unknown error occurred' });
  }
});

// Load user game state
router.get('/save/:userId', async (req: Request, res: Response) => {
  const { userId } = req.params;
  if (!userId) {
    return res.status(400).json({ error: 'userId is required' });
  }

  try {
    const db = getDb();
    const doc = await db
      .collection('users')
      .doc(userId as string)
      .get();
    if (!doc.exists) {
      return res.status(404).json({ error: 'Save not found' });
    }
    res.json(doc.data());
  } catch (err: unknown) {
    console.error('Error loading game state', err);
    res.status(500).json({ error: err instanceof Error ? err.message : 'Unknown error occurred' });
  }
});

export default router;
