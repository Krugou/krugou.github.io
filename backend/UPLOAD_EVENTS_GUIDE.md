# Firebase Events Upload Guide

This directory contains scripts to upload event data from JSON files to Firebase Firestore for "The Immigrants" game.

## 📋 Overview

The upload script reads the game's event data from JSON files and uploads them to Firebase Firestore with the correct structure expected by the Flutter app. This is essential for the Firebase-powered event system.

## 🚀 Quick Start

### 1. Prerequisites

- Python 3.8 or higher
- Firebase project with Firestore enabled
- Firebase Admin SDK credentials

### 2. Setup Environment

Run the setup script first:

```bash
# Windows
python setup.py

# Linux/Mac
python3 setup.py
```

This will:
- Create a virtual environment
- Install required packages
- Create Firebase config template

### 3. Configure Firebase Credentials

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to Project Settings → Service Accounts
4. Click "Generate new private key"
5. Save the JSON file as `firebase_config.json` in the backend directory

### 4. Upload Events

#### Windows:
```cmd
# Preview upload (dry run)
upload_events_to_firebase.bat --dry-run --verbose

# Upload events
upload_events_to_firebase.bat

# Force overwrite existing events
upload_events_to_firebase.bat --force
```

#### Linux/Mac:
```bash
# Make script executable
chmod +x upload_events_to_firebase.sh

# Preview upload (dry run)
./upload_events_to_firebase.sh --dry-run --verbose

# Upload events
./upload_events_to_firebase.sh

# Force overwrite existing events
./upload_events_to_firebase.sh --force
```

## 📁 File Structure

```
backend/
├── upload_events_to_firebase.py    # Main upload script
├── upload_events_to_firebase.bat   # Windows batch runner
├── upload_events_to_firebase.sh    # Linux/Mac shell runner
├── firebase_config.json            # Your Firebase credentials (create this)
├── firebase_config_template.json   # Template for credentials
└── requirements.txt                # Python dependencies

../assets/events/
├── territory_events.json           # Territory-based events
└── milestone_events.json           # Population milestone events
```

## 🔧 Script Options

### Command Line Arguments

| Option | Description |
|--------|-------------|
| `--dry-run` | Preview what would be uploaded without actually uploading |
| `--force` | Overwrite existing data in Firebase without prompting |
| `--verbose` | Enable detailed logging |
| `--list-existing` | List existing events in Firebase and exit |
| `--verify-only` | Only verify existing uploads without uploading new data |
| `--config PATH` | Specify custom path to Firebase config file |

### Usage Examples

```bash
# Basic upload
python upload_events_to_firebase.py

# Preview upload with detailed logging
python upload_events_to_firebase.py --dry-run --verbose

# Force overwrite existing data
python upload_events_to_firebase.py --force --verbose

# List what's already in Firebase
python upload_events_to_firebase.py --list-existing

# Verify previous upload
python upload_events_to_firebase.py --verify-only

# Use custom config file
python upload_events_to_firebase.py --config my_firebase_config.json
```

## 🔥 Firebase Structure

The script uploads events to Firebase with this structure:

```
Firestore Collection: events/
├── territory_events/
│   ├── rural: [array of rural events]
│   ├── urban: [array of urban events]
│   ├── border: [array of border events]
│   ├── coastal: [array of coastal events]
│   ├── caves: [array of cave events]
│   ├── underground: [array of underground events]
│   ├── mountains: [array of mountain events]
│   ├── desert: [array of desert events]
│   ├── arctic: [array of arctic events]
│   ├── orbital: [array of orbital events]
│   └── space_station: [array of space station events]
└── milestone_events/
    └── milestones: [array of milestone events]
```

## 📊 Event Data Validation

The script validates event data before uploading:

### Territory Events
- **Required fields**: `id`, `title`, `description`, `type`, `populationChange`, `probability`, `category`
- **Data types**: `populationChange` (number), `probability` (0-1 range)
- **Unique IDs**: All events must have unique identifiers

### Milestone Events
- **Additional required**: `threshold` field for population milestones
- **Special handling**: Achievement events with territory unlock triggers

## 🛠️ Troubleshooting

### Common Issues

1. **Firebase connection failed**
   ```
   Error: Failed to initialize Firebase
   ```
   - Check your `firebase_config.json` file
   - Verify Firebase project ID
   - Ensure Firestore is enabled

2. **JSON file not found**
   ```
   Error: Events directory not found
   ```
   - Ensure you're running from the backend directory
   - Check that `../assets/events/` exists
   - Verify JSON files are present

3. **Permission denied**
   ```
   Error: Insufficient permissions
   ```
   - Check Firebase security rules
   - Verify service account permissions
   - Ensure Firestore write access

4. **Invalid JSON format**
   ```
   Error: Invalid JSON in territory_events.json
   ```
   - Validate JSON syntax
   - Check for missing commas or brackets
   - Use a JSON validator tool

### Debug Mode

Enable verbose logging for detailed output:

```bash
python upload_events_to_firebase.py --verbose --dry-run
```

This shows:
- Detailed validation steps
- Firebase connection status
- Individual event processing
- Upload progress

## 🔐 Security Considerations

### Firebase Credentials
- Never commit `firebase_config.json` to version control
- Use environment variables in production
- Rotate service account keys regularly
- Limit service account permissions

### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read access to events for all users
    match /events/{document} {
      allow read: if true;
      // Only allow writes from admin service accounts
      allow write: if request.auth != null &&
                      request.auth.token.admin == true;
    }
  }
}
```

## 📈 Performance Optimization

### Batch Operations
- Events are uploaded in optimized batches
- Validation occurs before upload
- Atomic operations prevent partial uploads

### Error Recovery
- Detailed error logging
- Rollback on failure
- Verification after upload

## 🎯 Integration with Flutter App

After successful upload, the Flutter app will:

1. **Automatically load** events from Firebase
2. **Fall back to JSON** if Firebase is unavailable
3. **Real-time sync** with any changes
4. **Cache events** for offline play

## 📝 Development Workflow

1. **Modify events** in JSON files
2. **Test locally** with `--dry-run`
3. **Upload to development** Firebase project
4. **Test in Flutter app**
5. **Upload to production** when ready

## 🆘 Support

For issues with the upload script:

1. Check the console output for specific error messages
2. Verify Firebase credentials and permissions
3. Validate JSON file structure and content
4. Test Firebase connection independently
5. Review the troubleshooting section above

For additional help, check:
- [Firebase Admin SDK Documentation](https://firebase.google.com/docs/admin/setup)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- Project's main README.md and FIREBASE_EVENT_MIGRATION.md
