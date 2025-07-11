// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'The Immigrants';

  @override
  String get territories => 'Territories';

  @override
  String totalPopulation(String population) {
    return 'Total: $population';
  }

  @override
  String get locked => 'LOCKED';

  @override
  String nextUnlock(String territory, String threshold) {
    return 'Next unlock: $territory at $threshold people';
  }

  @override
  String get allTerritoriesUnlocked => 'All territories unlocked!';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get gameSpeed => 'Game Speed';

  @override
  String get normalSpeed => 'Normal';

  @override
  String get fastSpeed => 'Fast';

  @override
  String get veryFastSpeed => 'Very Fast';

  @override
  String get slowSpeed => 'Slow';

  @override
  String get territoryUrbanCenterName => 'Urban Center';

  @override
  String get territoryUrbanCenterDescription =>
      'A bustling city with job opportunities and cultural diversity';

  @override
  String get territoryBorderTownName => 'Border Town';

  @override
  String get territoryBorderTownDescription =>
      'A strategic location for those seeking refuge and new beginnings';

  @override
  String get territoryCoastalPortName => 'Coastal Port';

  @override
  String get territoryCoastalPortDescription =>
      'A maritime hub with fishing and trade opportunities';

  @override
  String get territoryCaveNetworkName => 'Cave Network';

  @override
  String get territoryCaveNetworkDescription =>
      'Underground caves providing shelter and protection';

  @override
  String get territoryUndergroundCityName => 'Underground City';

  @override
  String get territoryUndergroundCityDescription =>
      'A hidden city beneath the surface with advanced facilities';

  @override
  String get territoryMountainSettlementName => 'Mountain Settlement';

  @override
  String get territoryMountainSettlementDescription =>
      'High-altitude community with stunning views and clean air';

  @override
  String get territoryDesertOutpostName => 'Desert Outpost';

  @override
  String get territoryDesertOutpostDescription =>
      'Solar-powered settlement in the harsh desert environment';

  @override
  String get territoryArcticBaseName => 'Arctic Base';

  @override
  String get territoryArcticBaseDescription =>
      'Research and residential facilities in the frozen wilderness';

  @override
  String get territoryOrbitalPlatformName => 'Orbital Platform';

  @override
  String get territoryOrbitalPlatformDescription =>
      'Space-based habitat orbiting Earth';

  @override
  String get territorySpaceStationAlphaName => 'Space Station Alpha';

  @override
  String get territorySpaceStationAlphaDescription =>
      'Advanced interplanetary hub for deep space exploration';
}
