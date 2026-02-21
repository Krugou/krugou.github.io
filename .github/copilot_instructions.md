# The Immigrants - Incremental Game Development Instructions

> **Agent workflow note:** After completing each step or adding any code, automatically stage, commit, and push your changes to the `main` branch. Keep the remote in sync so future agents have the latest state.

## Project Overview

You are helping develop "The Immigrants", a Flutter web/Android incremental game about population movement and territory expansion. The game features a single resource (people) that increases/decreases as immigrants move into new territories through random events.

## Game Mechanics to Implement

### Core Systems

- **Single Resource**: People as the only resource
- **Territory Expansion**: Unlock new territories through population thresholds
- **Event System**: Random events that trigger population movement
- **Population Migration**: People move between territories based on events

### Key Features

- Population counter (main resource)
- Territory unlock system
- Random event generator with separate event lists per territory
- Population migration between territories
- Event outcomes affecting population numbers
- Auto-save/load functionality

### Resource Mechanics

- **People**: The only resource in the game
- **Population Growth**: Increases through positive events (births, immigration)
- **Population Loss**: Decreases through negative events (emigration, disasters)
- **Territory Capacity**: Each territory has population limits

### Event System

- **Separate Event Lists**: Each territory has its own event pool
- **Random Triggers**: Events fire based on timers or population thresholds
- **Population Effects**: Events directly increase/decrease people count
- **Territory Migration**: Events can move people between territories
- **Event Types**: Immigration waves, natural disasters, economic opportunities, conflicts

### Territory System

- **Territory Unlock**: New territories unlock at population milestones
- **Population Distribution**: People spread across available territories
- **Territory Events**: Each territory has unique event types
- **Migration Paths**: People can move between connected territories

## Technical Requirements

### Flutter Structure

- Use Provider for state management
- Implement game loop with Timer.periodic for events
- SharedPreferences for save/load
- Responsive UI for web and mobile
- Material Design components

### Code Patterns

- Separate event logic from UI
- Use notifyListeners() for population updates
- Implement event probability systems
- Add number formatting for population counts
- Territory-specific event pools

### UI Components Needed

- Population counter (prominent display)
- Territory list with population breakdown
- Event log/history display
- Territory unlock indicators
- Event outcome notifications
- Settings/reset options

## Naming Conventions

- Use snake_case for variables and functions
- Use PascalCase for classes
- Prefix private variables with underscore
- Use descriptive names related to immigration and territory themes

## Immigration Theme Elements

- Territory types (rural villages, urban centers, border regions)
- Event categories (economic migration, family reunification, refuge seeking)
- Population dynamics (birth rates, emigration patterns)
- Migration reasons (opportunity, safety, family)
- Territory characteristics affecting event types

## Event System Details

- **Event Structure**: Each event has description, population effect, probability
- **Territory Events**: Events specific to territory type and current population
- **Chain Events**: Some events can trigger follow-up events
- **Seasonal Events**: Time-based events that occur periodically
- **Milestone Events**: Population threshold events that unlock content

## Performance Considerations

- Optimize event calculation loops
- Use efficient population counting
- Implement proper widget rebuilding for population updates
- Consider event history cleanup for memory management
- Add settings for event frequency

When writing code, focus on event-driven population mechanics, territory expansion, and creating meaningful immigration narratives through the event system.

do not use vscode tasks and always use commands that auto quit after execution. Always ensure to stage, commit, and push changes after each code addition or modification to keep the remote repository up to date for future agents.
