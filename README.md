# The Immigrants - Enhanced Incremental Game

An advanced event-driven incremental game about population movement and territory expansion, featuring Firebase integration, JSON-based event system, and progression from caves to space stations. Developed with Flutter for web and mobile platforms.

## 🎮 Game Overview

Experience the dynamic world of migration as you manage population movement across an expanded universe of territories. Guide your communities through an epic journey from humble cave dwellings to advanced space stations, responding to ever-changing circumstances in this enhanced immigration-themed incremental game.

## 🚀 New Features

### 🔥 Firebase Integration
- **User Authentication**: Sign up, sign in, and manage your account
- **Cloud Save**: Your progress syncs across all devices
- **Leaderboards**: Compete with other players globally
- **Real-time Data**: Secure cloud storage for game state

### 📋 JSON Event System
- **Flexible Events**: Events loaded from JSON files for easy customization
- **Event Categories**: Opportunities, disasters, conflicts, epidemics, and more
- **Extensive Library**: 50+ unique events across all territories
- **Easy Expansion**: Add new events without code changes

### 🌍 Expanded Territory Progression
- **11 Territory Types**: From rural villages to space stations
- **Epic Journey**: Caves → Underground → Mountains → Desert → Arctic → Orbital → Space Station
- **Unique Events**: Each territory has specialized events and challenges
- **Progressive Unlocks**: Territories unlock based on population milestones

## 🏗️ Core Mechanics

### Single Resource System
- **People**: The only resource - track population growth and movement
- **Population Dynamics**: Numbers change through births, immigration, emigration, and disasters
- **Territory Distribution**: People spread across multiple unlocked territories

### Enhanced Territory System
- **Progressive Unlocking**: 11 territories unlock at different population milestones
- **Territory Types**: 
  - Rural Villages (Starting point)
  - Urban Centers (25+ population)
  - Border Towns (50+ population)
  - Coastal Ports (75+ population)
  - Cave Networks (100+ population)
  - Underground Cities (150+ population)
  - Mountain Settlements (200+ population)
  - Desert Outposts (300+ population)
  - Arctic Bases (400+ population)
  - Orbital Platforms (500+ population)
  - Space Stations (750+ population)

### Advanced Event System
- **JSON-Driven**: Events loaded from `assets/events/` directory
- **Category-Based**: Events organized by type (opportunity, disaster, conflict, epidemic)
- **Territory-Specific**: Each territory has unique event pools
- **Milestone Events**: Special events triggered by population thresholds
- **Negative Events**: Disasters, conflicts, and epidemics that create challenges

## 🎯 Key Features

### Game Mechanics
- **Event System**: JSON-based random events drive all population changes
- **Territory Management**: Unlock and manage 11 distinct territory types
- **Population Migration**: Watch people move between territories based on events
- **Achievement System**: Track milestones and unlock special territories
- **Auto-Save**: Progress automatically saved locally and to cloud

### User Experience
- **Cross-Platform**: Responsive design for web and mobile devices
- **Firebase Auth**: Secure user registration and login
- **Cloud Sync**: Save progress across multiple devices
- **Leaderboards**: Global competition system
- **Offline Play**: Continue playing without internet connection

## 📚 Event Types

### Immigration Events
- **Economic Migration**: People move seeking better opportunities
- **Family Reunification**: Families join relatives in new territories
- **Refuge Seeking**: Population displacement due to conflicts or disasters
- **Research Opportunities**: Scientists and specialists joining advanced territories

### Negative Events
- **Natural Disasters**: Earthquakes, floods, droughts, avalanches, tsunamis
- **Conflicts**: Political tensions, civil unrest, border closures
- **Epidemics**: Disease outbreaks affecting population health
- **Resource Depletion**: Shortages causing population decline
- **Technical Failures**: Space station malfunctions, life support issues

### Territory-Specific Events
- **Caves**: Collapses, mineral discoveries, flooding
- **Underground**: Contamination, oxygen crises, geothermal opportunities
- **Mountains**: Avalanches, altitude sickness, mining opportunities
- **Desert**: Sandstorms, heat waves, solar energy developments
- **Arctic**: Blizzards, ice melting, resource extraction
- **Orbital**: Space debris, life support failures, construction projects
- **Space Stations**: Reactor failures, alien contact, cosmic radiation

## 🛠️ Technical Implementation

### Core Technologies
- **Flutter 3.16+**: Cross-platform development framework
- **Firebase**: Authentication, Firestore database, cloud functions
- **Provider**: State management for real-time updates
- **Flame**: Game engine for visual elements
- **JSON**: Event data storage and loading

### Architecture
- **Event-Driven**: All game mechanics driven by event system
- **State Management**: Provider pattern for reactive UI updates
- **Cloud Integration**: Firebase for user data and synchronization
- **Modular Design**: Separate services for auth, database, and events

### Firebase Setup
```dart
// Add to your Firebase project configuration
FirebaseOptions(
  apiKey: 'your-api-key',
  authDomain: 'your-project.firebaseapp.com',
  projectId: 'your-project-id',
  storageBucket: 'your-project.appspot.com',
  messagingSenderId: 'your-sender-id',
  appId: 'your-app-id',
)
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.16 or later
- Firebase project (for cloud features)
- Git for version control

### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/Krugou/krugou.github.io.git
   cd krugou.github.io
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at https://console.firebase.google.com
   - Enable Authentication and Firestore
   - Update Firebase configuration in `lib/main.dart`

4. **Run the application**
   ```bash
   # For web
   flutter run -d web
   
   # For mobile
   flutter run
   ```

### Development Scripts
Use the provided development script for common tasks:

```bash
# Setup project
./dev.sh setup

# Run on web
./dev.sh web

# Run on mobile
./dev.sh android

# Build for production
./dev.sh build

# Run tests
./dev.sh test
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase init
├── models/
│   ├── game_state.dart      # Game state management
│   └── event_system.dart    # Enhanced event system
├── providers/
│   └── game_provider.dart   # Game logic with Firebase
├── services/
│   ├── auth_service.dart    # Firebase authentication
│   └── database_service.dart # Firestore operations
├── screens/
│   ├── game_screen.dart     # Main game interface
│   └── auth/
│       ├── login_screen.dart
│       └── signup_screen.dart
├── widgets/                 # UI components
└── utils/                   # Helper functions

assets/
└── events/
    ├── territory_events.json    # Territory-specific events
    └── milestone_events.json    # Milestone events
```

## 🎮 JSON Event Format

Events are defined in JSON files for easy customization:

```json
{
  "rural": [
    {
      "id": "rural_harvest",
      "title": "Good Harvest",
      "description": "A successful harvest attracts new families.",
      "type": "immigration",
      "populationChange": 2.0,
      "probability": 0.3,
      "category": "opportunity"
    }
  ]
}
```

### Event Properties
- **id**: Unique identifier
- **title**: Event name
- **description**: Event description
- **type**: Event type (immigration, emigration, disaster, etc.)
- **populationChange**: Population impact (positive or negative)
- **probability**: Chance of occurring (0.0 to 1.0)
- **category**: Event category for filtering

## 🔧 Configuration

### Firebase Configuration
1. Create a Firebase project
2. Enable Authentication (Email/Password)
3. Enable Firestore Database
4. Update Firebase configuration in `lib/main.dart`

### Event Customization
- Edit `assets/events/territory_events.json` to modify territory events
- Edit `assets/events/milestone_events.json` to modify milestone events
- Add new event categories by updating the JSON structure

## 🎯 Gameplay Progression

### Population Milestones
- **10 People**: Growing Community achievement
- **25 People**: Urban Center unlocked
- **50 People**: Border Town unlocked
- **75 People**: Coastal Port unlocked
- **100 People**: Cave Network unlocked
- **150 People**: Underground City unlocked
- **200 People**: Mountain Settlement unlocked
- **300 People**: Desert Outpost unlocked
- **400 People**: Arctic Base unlocked
- **500 People**: Orbital Platform unlocked
- **750 People**: Space Station unlocked

### Strategy Tips
- Balance population growth with territory capacity
- Prepare for negative events by diversifying populations
- Use manual immigration to boost struggling territories
- Monitor event patterns to predict challenges
- Aim for milestone achievements to unlock new territories

## 🤝 Contributing

We welcome contributions to enhance the game:

### Areas for Contribution
- **New Events**: Add events to JSON files
- **Territory Types**: Propose new territory concepts
- **UI/UX**: Improve user interface and experience
- **Performance**: Optimize for larger populations
- **Features**: Suggest new gameplay mechanics

### Development Guidelines
- Follow Flutter best practices
- Maintain JSON event format consistency
- Test changes across web and mobile platforms
- Document new features and APIs

## 📄 License

This project is open source under the MIT License. Feel free to use, modify, and distribute as needed.

## 🌟 Acknowledgments

- Flutter team for the amazing framework
- Firebase for robust cloud infrastructure
- The open-source community for inspiration and support
- All contributors who help improve the game

---

**Experience the journey from caves to space stations. Build your immigrant communities across the universe! 🚀**
