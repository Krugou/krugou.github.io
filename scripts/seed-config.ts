import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import fs from 'fs';
import path from 'path';

// Load Service Account
// Based on backend/firebase.ts investigation:
const serviceAccountPath = path.resolve(
  process.cwd(),
  'backend',
  'immigrants-game-firebase-adminsdk-fbsvc-da4aa4541e.json',
);

if (!fs.existsSync(serviceAccountPath)) {
  console.error(`Service account file not found at: ${serviceAccountPath}`);
  process.exit(1);
}
const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));

initializeApp({
  credential: cert(serviceAccount),
});

const db = getFirestore();

const TERRITORY_TYPES = [
  'rural',
  'suburbs',
  'urban',
  'metropolis',
  'border',
  'coastal',
  'caves',
  'underground',
  'mountains',
  'desert',
  'arctic',
  'moon',
  'orbital',
  'spaceStation',
  'interstellar',
  'milestone',
];

const EVENT_TYPES = ['immigration', 'emigration', 'disaster', 'opportunity', 'milestone'];
const CATEGORIES = ['opportunity', 'disaster', 'milestone', 'neutral'];

const seed = async () => {
  console.log('Seeding system configuration...');
  try {
    await db.collection('config').doc('metadata').set({
      territoryTypes: TERRITORY_TYPES,
      eventTypes: EVENT_TYPES,
      categories: CATEGORIES,
      updatedAt: Date.now(),
      seededAt: Date.now(),
    });
    console.log('✅ Configuration seeded successfully.');
  } catch (error) {
    console.error('❌ Error seeding config:', error);
  } finally {
    process.exit();
  }
};

seed();
