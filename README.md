# The Immigrants - Flutter Game

An incremental game about building immigrant communities, developed with Flutter and the Flame game engine.

## Game Overview

Help build a thriving immigrant community by managing resources, population growth, and community upgrades. Watch as your settlement grows from a small group of immigrants to a bustling community!

## Features

- **Resource Management**: Manage food, housing, and happiness to sustain your growing population
- **Population Growth**: Attract new immigrants through community happiness and upgrades
- **Community Upgrades**: Build farms, houses, schools, hospitals, ports, and workshops
- **Incremental Progression**: Manual actions and passive income systems
- **Auto-Save**: Your progress is automatically saved
- **Cross-Platform**: Runs on web and mobile devices

## Game Mechanics

### Resources
- **Food**: Consumed by population, produced by farms and manual gathering
- **Housing**: Needed for population growth, built through housing upgrades
- **Happiness**: Affects immigration rate, improved by schools and resource balance

### Actions
- **Gather Food**: Manually collect food for your community
- **Welcome Immigrant**: Spend food to immediately add a new community member

### Upgrades
- **Farms**: Increase food production (+2 food/sec each)
- **Houses**: Provide housing (+1.5 housing/sec each)
- **Schools**: Boost community happiness (+5 happiness each)
- **Hospitals**: Reduce resource consumption (-10% each)
- **Ports**: Increase immigration rate (+20% each)
- **Workshops**: Improve manual food gathering (+50% each)

## Technical Details

Built with:
- Flutter 3.16+
- Flame game engine
- Provider for state management
- SharedPreferences for save/load functionality
- Responsive design for web and mobile

## Getting Started

1. Install Flutter SDK
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run -d web` for web or `flutter run` for mobile

## Building for Web

To build for GitHub Pages:
```bash
flutter build web --base-href /krugou.github.io/
```

## Contributing

This is an open-source project. Feel free to contribute improvements, bug fixes, or new features!

## License

Open source - feel free to use and modify as needed.