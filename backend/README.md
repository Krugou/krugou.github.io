# The Immigrants - Event Management Backend

A Python Qt application for managing game events in Firebase. This backend provides a responsive GUI for adding, editing, and deleting events used in The Immigrants game.

## Features

- **Firebase Integration**: Direct connection to Firebase Firestore
- **Event Management**: Add, edit, delete, and view all game events
- **Responsive UI**: Clean, modern interface built with PyQt6
- **Event Categories**: Support for all event types (immigration, disasters, milestones, etc.)
- **Territory Management**: Events organized by territory types
- **Real-time Updates**: Changes sync immediately with Firebase
- **Validation**: Input validation and error handling
- **Offline Support**: Graceful handling of connection issues

## Requirements

- Python 3.8 or higher
- PyQt6
- Firebase Admin SDK
- Firebase project with Firestore enabled

## Installation

### Option 1: Automatic Setup (Recommended)

1. **Run the setup script:**
   ```bash
   python setup.py
   ```

2. **Configure Firebase:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Navigate to Project Settings → Service Accounts
   - Generate a new private key
   - Download the JSON file
   - Replace `firebase_config_template.json` with your credentials
   - Rename it to `firebase_config.json`

3. **Run the application:**
   ```bash
   # Windows
   run_event_manager.bat
   
   # macOS/Linux
   ./run_event_manager.sh
   ```

### Option 2: Manual Setup

1. **Create virtual environment:**
   ```bash
   python -m venv venv
   
   # Windows
   venv\Scripts\activate
   
   # macOS/Linux
   source venv/bin/activate
   ```

2. **Install requirements:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Configure Firebase credentials** (see above)

4. **Run the application:**
   ```bash
   python event_manager.py
   ```

## Usage

### Initial Setup

1. **Launch the application**
2. **Connect to Firebase:**
   - Enter path to your Firebase credentials JSON file
   - Click "Connect"
   - Wait for successful connection

3. **Manage Events:**
   - View all existing events in the table
   - Add new events with the "Add Event" button
   - Edit existing events by selecting and clicking "Edit Event"
   - Delete events with the "Delete Event" button
   - Refresh the list with the "Refresh" button

### Event Properties

Each event has the following properties:

- **ID**: Unique identifier for the event
- **Title**: Display name of the event
- **Description**: Detailed description shown to players
- **Type**: Event type (immigration, emigration, disaster, milestone)
- **Territory Type**: Which territory this event applies to
- **Population Change**: How the event affects population (+/- numbers)
- **Probability**: Chance of the event occurring (0.0 to 1.0)
- **Category**: Event category (opportunity, disaster, conflict, etc.)
- **Threshold**: Population threshold for milestone events

### Territory Types

Supported territory types:
- **rural**: Rural villages
- **urban**: Urban centers
- **border**: Border towns
- **coastal**: Coastal ports
- **caves**: Cave networks
- **underground**: Underground cities
- **mountains**: Mountain settlements
- **desert**: Desert outposts
- **arctic**: Arctic bases
- **orbital**: Orbital platforms
- **space_station**: Space stations
- **milestone**: Milestone events (special)

### Event Categories

Available categories:
- **opportunity**: Positive events that attract immigrants
- **disaster**: Natural disasters and accidents
- **conflict**: Political tensions and conflicts
- **epidemic**: Disease outbreaks and health issues
- **milestone**: Population milestone achievements

## Firebase Structure

The backend manages events in Firebase Firestore with this structure:

```
events/
├── territory_events/
│   ├── rural: [array of events]
│   ├── urban: [array of events]
│   └── ...
├── milestone_events/
│   └── milestones: [array of milestone events]
└── custom_events/
    └── events/
        └── [individual event documents]
```

## Integration with Flutter App

The Flutter app automatically loads events from Firebase when available, with JSON fallback:

1. **Firebase Priority**: Events are loaded from Firebase first
2. **JSON Fallback**: If Firebase is unavailable, loads from local JSON files
3. **Real-time Updates**: Changes made in this backend appear in the game immediately
4. **Offline Support**: Game continues to work even when Firebase is down

## Development

### Project Structure

```
backend/
├── event_manager.py       # Main application
├── setup.py              # Setup script
├── requirements.txt      # Python dependencies
├── firebase_config_template.json  # Firebase config template
└── README.md            # This file
```

### Key Components

- **FirebaseManager**: Handles Firebase connection and operations
- **EventEditDialog**: Dialog for editing event properties
- **EventManagementWidget**: Main widget for event management
- **MainWindow**: Application main window

### Adding New Features

1. **New Event Properties**: Add fields to `EventEditDialog`
2. **New Territory Types**: Update territory combo box options
3. **New Categories**: Add to category combo box
4. **Custom Validation**: Modify `get_event_data()` method

## Troubleshooting

### Common Issues

1. **Firebase Connection Failed**
   - Check credentials file path
   - Verify Firebase project ID
   - Ensure Firestore is enabled
   - Check network connectivity

2. **PyQt6 Installation Issues**
   - Update pip: `pip install --upgrade pip`
   - Try: `pip install PyQt6 --force-reinstall`
   - On Linux: `sudo apt-get install python3-pyqt6`

3. **Permission Errors**
   - Ensure Firebase service account has Firestore permissions
   - Check if credentials file is readable

### Debugging

Enable debug logging by modifying the logging level in `event_manager.py`:

```python
logging.basicConfig(level=logging.DEBUG)
```

## Security

- **Service Account**: Use Firebase service account with minimal permissions
- **Credentials**: Keep Firebase credentials secure and never commit to version control
- **Network**: Consider using Firebase security rules for production

## Support

For issues with the backend:
1. Check the console output for error messages
2. Verify Firebase credentials and permissions
3. Test Firebase connection independently
4. Check Python and PyQt6 versions

## License

This project is open source under the MIT License.