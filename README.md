# The Immigrants - Incremental Game

An event-driven incremental game about population movement and territory expansion, developed with Flutter for web and mobile platforms.

## Game Overview

Experience the dynamic world of migration as you manage population movement across territories through random events. Watch as people move between regions, settle new lands, and respond to ever-changing circumstances in this immigration-themed incremental game.

## Core Mechanics

### Single Resource System

- **People**: The only resource - track population growth and movement
- **Population Dynamics**: Numbers change through births, immigration, emigration, and disasters
- **Territory Distribution**: People spread across multiple unlocked territories

### Territory Expansion

- **Progressive Unlocking**: New territories become available at population milestones
- **Territory Types**: Rural villages, urban centers, border regions - each with unique characteristics
- **Population Limits**: Each territory has capacity constraints affecting migration patterns

### Event-Driven Gameplay

- **Random Events**: Immigration waves, natural disasters, economic opportunities, conflicts
- **Territory-Specific Events**: Each region has its own event pool reflecting local conditions
- **Population Effects**: Events directly impact people count and trigger migrations
- **Chain Events**: Some events lead to follow-up consequences
- **Migration Triggers**: Events cause people to move between connected territories

## Key Features

- **Event System**: Random events drive all population changes and story progression
- **Territory Management**: Unlock and manage multiple regions with distinct characteristics
- **Population Migration**: Watch people move between territories based on events
- **Immigration Narratives**: Experience meaningful stories of migration through event descriptions
- **Auto-Save**: Progress automatically saved with offline event processing
- **Cross-Platform**: Responsive design for web and mobile devices

## Event Types

### Immigration Events

- **Economic Migration**: People move seeking better opportunities
- **Family Reunification**: Families join relatives in new territories
- **Refuge Seeking**: Population displacement due to conflicts or disasters
- **Seasonal Migration**: Temporary movement based on work or climate

### Territory Events

- **Natural Disasters**: Earthquakes, floods, droughts affecting population
- **Economic Opportunities**: Job markets, resource discoveries attracting migrants
- **Infrastructure Development**: Roads, schools, hospitals improving territory appeal
- **Conflicts**: Political tensions or violence causing population displacement

### Milestone Events

- **Population Thresholds**: Special events triggered when reaching certain population levels
- **Territory Unlocks**: New regions become available as communities grow
- **Chain Reactions**: Events that trigger follow-up consequences across territories

## Technical Implementation

Built with:

- Flutter 3.16+ for cross-platform development
- Provider for state management and population tracking
- Timer.periodic for event system and population updates
- SharedPreferences for persistent save/load functionality
- Material Design for responsive UI components
- Event-driven architecture for population mechanics

## Getting Started

1. Install Flutter SDK (3.16 or later)
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run -d web` for web or `flutter run` for mobile

## Building for Web

To build for GitHub Pages:

```bash
flutter build web --base-href /krugou.github.io/
```

## Game Development Architecture

- **Event System**: Random event generation with territory-specific pools
- **Population Mechanics**: Single resource (people) with migration patterns
- **Territory Management**: Progressive unlock system with capacity limits
- **State Persistence**: Auto-save with offline event processing
- **UI Components**: Population displays, territory panels, event notifications

## Contributing

This is an open-source immigration simulation game. Contributions welcome for:

- New event types and immigration narratives
- Additional territory mechanics and features
- UI/UX improvements for population visualization
- Performance optimizations for large populations

## License

Open source - feel free to use and modify as needed.
