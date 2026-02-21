import admin from 'firebase-admin';
import fs from 'fs';

export const initFirebase = () => {
  if (admin.apps.length) return;

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
    console.log('Firebase admin initialized with service account');
  } else {
    admin.initializeApp();
    console.warn('Firebase admin initialized with default credentials');
  }
};

export const getDb = () => {
  initFirebase();
  return admin.firestore();
};

export default admin;
