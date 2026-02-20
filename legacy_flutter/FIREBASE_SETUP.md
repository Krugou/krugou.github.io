# Firebase Configuration Guide

This document explains how to configure Firebase for The Immigrants game.

## Firebase Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Follow the setup wizard

### 2. Enable Authentication
1. In your Firebase project, go to Authentication
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" provider

### 3. Enable Firestore Database
1. Go to Firestore Database
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select your preferred location

### 4. Configure Web App
1. Go to Project settings (gear icon)
2. Click "Add app" and select Web
3. Register your app with a nickname
4. Copy the configuration object

### 5. Update Configuration
Replace the Firebase configuration in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'your-api-key-here',
    authDomain: 'your-project.firebaseapp.com',
    projectId: 'your-project-id',
    storageBucket: 'your-project.appspot.com',
    messagingSenderId: 'your-sender-id',
    appId: 'your-app-id',
  ),
);
```

## Security Rules

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Allow access to gameData subcollection
      match /gameData/{document} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### Storage Rules (if using Firebase Storage)
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Development vs Production

### Development
- Use test mode for Firestore
- Enable all authentication methods for testing
- Use localhost domains

### Production
- Update Firestore rules to be more restrictive
- Add your production domain to authorized domains
- Enable only necessary authentication methods

## Environment Variables

For production deployment, consider using environment variables:

```dart
// Example environment-based configuration
const firebaseConfig = FirebaseOptions(
  apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
  authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
  projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
  storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
  messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
  appId: String.fromEnvironment('FIREBASE_APP_ID'),
);
```

## Testing

### Local Testing
1. Use Firebase Emulator Suite for local development
2. Install Firebase CLI: `npm install -g firebase-tools`
3. Start emulators: `firebase emulators:start`

### Authentication Testing
- Create test accounts with different email formats
- Test password reset functionality
- Verify sign-out behavior

### Database Testing
- Test data synchronization between devices
- Verify offline functionality
- Check data persistence after app restart

## Troubleshooting

### Common Issues
1. **Authentication not working**: Check if email/password is enabled
2. **Firestore permission denied**: Verify security rules
3. **Configuration errors**: Double-check Firebase config object
4. **CORS issues**: Add your domain to Firebase hosting or authorized domains

### Debug Mode
Enable debug mode for more detailed error messages:
```dart
// Add to main.dart for development
if (kDebugMode) {
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
```

## Production Deployment

### Web Deployment
1. Build the app: `flutter build web`
2. Deploy to Firebase Hosting or GitHub Pages
3. Update authorized domains in Firebase Console

### Security Checklist
- [ ] Update Firestore security rules
- [ ] Remove debug configurations
- [ ] Use environment variables for sensitive data
- [ ] Enable only necessary authentication methods
- [ ] Set up proper CORS policies
- [ ] Monitor Firebase usage and quotas

## Support

For issues with Firebase configuration:
1. Check Firebase Console for error messages
2. Review Firebase documentation
3. Use Firebase support channels
4. Check Flutter Fire documentation at https://firebase.flutter.dev/