import admin from 'firebase-admin';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const SERVICE_ACCOUNT_PATH = path.join(
  __dirname,
  'immigrants-game-firebase-adminsdk-fbsvc-da4aa4541e.json',
);

export const initFirebase = () => {
  if (admin.apps.length) return;

  // 1. Try local service account file in backend/
  if (fs.existsSync(SERVICE_ACCOUNT_PATH)) {
    const serviceAccount = JSON.parse(fs.readFileSync(SERVICE_ACCOUNT_PATH, 'utf8')) as Record<
      string,
      unknown
    >;
    admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
    console.log('Firebase admin initialized with local service account');
    return;
  }

  // 2. Try env-based service account
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
    admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
    console.log('Firebase admin initialized with service account from env');
  } else {
    const projectId =
      process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID || process.env.FIREBASE_PROJECT_ID;
    if (projectId) {
      admin.initializeApp({ projectId });
      console.warn(`Firebase admin initialized with projectId: ${projectId}`);
    } else {
      admin.initializeApp();
      console.warn('Firebase admin initialized with default credentials');
    }
  }
};

export const getDb = () => {
  initFirebase();
  return admin.firestore();
};

export default admin;
