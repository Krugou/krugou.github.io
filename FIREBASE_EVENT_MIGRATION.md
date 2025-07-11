# Firebase Event Management Migration Guide

This guide explains how the event management system has been transitioned from JSON-based to Firebase-powered with Python Qt backend.

## Overview

The Immigrants game now uses Firebase Firestore as the primary event storage system, with several key improvements:

- **Firebase-first**: Events are loaded from Firebase Firestore
- **Python Qt Backend**: Responsive GUI for managing events
- **JSON Fallback**: Game still works if Firebase is unavailable
- **Real-time Updates**: Changes sync immediately across all platforms

## Architecture Changes

### Before (JSON-based)
```
Game → JSON Files → Event System
```

### After (Firebase-powered)
```
Python Qt Backend → Firebase Firestore → Game
                         ↓
                     JSON Files (fallback)
```

## Firebase Structure

Events are stored in Firebase Firestore with this structure:

```
events/
├── territory_events/
│   ├── rural: [array of events]
│   ├── urban: [array of events]
│   ├── border: [array of events]
│   ├── coastal: [array of events]
│   ├── caves: [array of events]
│   ├── underground: [array of events]
│   ├── mountains: [array of events]
│   ├── desert: [array of events]
│   ├── arctic: [array of events]
│   ├── orbital: [array of events]
│   └── space_station: [array of events]
├── milestone_events/
│   └── milestones: [array of milestone events]
└── custom_events/
    └── events/
        └── [individual custom event documents]
```

## Event Loading Flow

1. **Firebase Attempt**: Event system tries to load from Firebase
2. **JSON Fallback**: If Firebase fails, loads from local JSON files
3. **Hardcoded Fallback**: If JSON fails, uses hardcoded events
4. **Real-time Updates**: Changes in Firebase sync to game immediately

## Python Qt Backend Features

### Event Management
- **Add Events**: Create new events with validation
- **Edit Events**: Modify existing events
- **Delete Events**: Remove events from Firebase
- **View Events**: Browse all events in a table

### Event Properties
- **Basic Info**: ID, title, description
- **Game Mechanics**: Type, population change, probability
- **Categorization**: Category, territory type
- **Special Properties**: Thresholds for milestone events

### User Interface
- **Responsive Design**: Scales well on different screen sizes
- **Form Validation**: Prevents invalid data entry
- **Error Handling**: Clear error messages and recovery
- **Real-time Updates**: Immediate sync with Firebase

## Migration Process

### 1. Upload Existing JSON to Firebase

Use the Flutter app to upload existing JSON events to Firebase:

```dart
// In your Flutter app
await EventSystem.uploadJsonToFirebase();
```

### 2. Set Up Python Backend

```bash
cd backend
python setup.py
```

### 3. Configure Firebase Credentials

1. Download Firebase service account key
2. Update `firebase_config_template.json` with your credentials
3. Rename to `firebase_config.json`

### 4. Run the Backend

```bash
# Linux/Mac
./run_event_manager.sh

# Windows
run_event_manager.bat
```

## API Integration

### Flutter Service Integration

The Firebase event service is automatically integrated into the Flutter app:

```dart
// Event system automatically uses Firebase
await EventSystem.initialize();

// Check if Firebase is available
bool isAvailable = await EventSystem.isFirebaseAvailable();

// Add custom events
await EventSystem.addCustomEvent(eventTemplate);
```

### Python Backend Integration

The Python backend connects directly to Firebase:

```python
# Connect to Firebase
firebase_manager = FirebaseManager()
firebase_manager.connect('path/to/credentials.json')

# Manage events
events = firebase_manager.get_all_events()
firebase_manager.add_event(event_data, territory_type)
```

## Configuration

### Firebase Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read access to events
    match /events/{document} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    
    // Users can manage their own custom events
    match /users/{userId}/customEvents/{eventId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Environment Variables

For production, use environment variables:

```bash
# .env file
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY_ID=your-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=your-service-account@project.iam.gserviceaccount.com
```

## Troubleshooting

### Common Issues

1. **Firebase Connection Failed**
   - Check credentials file path
   - Verify Firebase project configuration
   - Ensure Firestore is enabled

2. **Python Backend Won't Start**
   - Verify Python 3.8+ is installed
   - Check PyQt6 installation
   - Ensure virtual environment is activated

3. **Events Not Loading**
   - Check Firebase security rules
   - Verify event structure in Firestore
   - Check console for error messages

### Debug Mode

Enable debug logging in the Flutter app:

```dart
// Add to main.dart
void main() async {
  if (kDebugMode) {
    print('Debug mode enabled');
  }
  // ... rest of main
}
```

Enable debug logging in Python backend:

```python
import logging
logging.basicConfig(level=logging.DEBUG)
```

## Best Practices

### Event Management
- Use descriptive event IDs
- Validate all input data
- Test events in development before production
- Keep event descriptions concise but informative

### Firebase Usage
- Use service accounts for backend access
- Implement proper security rules
- Monitor Firebase usage and quotas
- Back up critical event data

### Development Workflow
1. Create/modify events in Python backend
2. Test in development environment
3. Verify changes in Flutter app
4. Deploy to production

## Performance Considerations

### Firebase Optimization
- Use indexes for frequently queried fields
- Implement pagination for large event sets
- Cache frequently accessed events
- Use Firebase offline persistence

### Python Backend Optimization
- Batch operations when possible
- Implement connection pooling
- Use async operations for better responsiveness
- Cache Firebase connection

## Future Enhancements

### Planned Features
- Event scheduling and timing
- A/B testing for event variations
- Analytics and event performance tracking
- Multi-language support for events
- Event templates and bulk operations

### Extensibility
- Plugin system for custom event types
- External API integration
- Advanced event validation rules
- Event versioning and rollback

## Support

For issues with the Firebase event system:
1. Check the console output for error messages
2. Verify Firebase credentials and permissions
3. Test Firebase connection independently
4. Review Firebase security rules
5. Check event data structure in Firestore

For Python backend issues:
1. Verify Python and PyQt6 installation
2. Check Firebase Admin SDK installation
3. Test Firebase connection with provided test script
4. Review backend logs for error messages