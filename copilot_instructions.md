# The Immigrants - Incremental Game Development Instructions

## Project Overview
You are helping develop "The Immigrants", a Flutter web/Android incremental game about building immigrant communities. The game features population growth, resource management, and settlement upgrades.

## Game Mechanics to Implement

### Core Systems
- **Population Growth**: Immigrants arrive over time based on happiness and upgrades
- **Resource Management**: Food, housing, happiness as core resources
- **Incremental Progression**: Manual actions, passive income, upgrades
- **Immigration Rate**: Affected by settlement conditions and upgrades

### Key Features
- Manual immigration button (costs food)
- Food gathering action
- Housing construction
- Upgrade system (farms, houses, schools, hospitals, ports, workshops)
- Happiness system affecting immigration rate
- Auto-save/load functionality

### Resource Mechanics
- **Food**: Consumed by population (0.1 per person/sec), produced by farms
- **Housing**: Consumed by population (0.05 per person/sec), produced by houses
- **Happiness**: Calculated from food/housing ratios, affects immigration rate
- **Population**: Grows through immigration, affected by happiness

### Upgrade System
- **Farms**: Increase food production (+2 food/sec each)
- **Houses**: Increase housing production (+1.5 housing/sec each)
- **Schools**: Boost happiness generation
- **Hospitals**: Reduce population resource consumption
- **Ports**: Increase immigration rate
- **Workshops**: Boost manual food gathering

## Technical Requirements

### Flutter Structure
- Use Provider for state management
- Implement game loop with Timer.periodic
- SharedPreferences for save/load
- Responsive UI for web and mobile
- Material Design components

### Code Patterns
- Separate game logic from UI
- Use notifyListeners() for state updates
- Implement upgrade cost scaling (exponential)
- Add number formatting for large values
- Include achievement/milestone system

### UI Components Needed
- Population counter (prominent display)
- Resource bars/counters
- Action buttons (immigrate, gather food, build shelter)
- Upgrade panels with cost/benefit display
- Progress indicators
- Settings/reset options

## Naming Conventions
- Use snake_case for variables and functions
- Use PascalCase for classes
- Prefix private variables with underscore
- Use descriptive names related to immigration theme

## Immigration Theme Elements
- Population types (families, skilled workers, refugees)
- Settlement buildings (community centers, cultural halls)
- Challenges (language barriers, integration)
- Achievements (population milestones, harmony goals)
- Narrative elements about building inclusive communities

## Performance Considerations
- Optimize game loop calculations
- Use efficient number formatting
- Implement proper widget rebuilding
- Consider BigInt for very large numbers
- Add settings for reduced animations on web

When writing code, focus on incremental game mechanics, immigration theming, and creating an engaging progression system that works well on both web and mobile platforms.
