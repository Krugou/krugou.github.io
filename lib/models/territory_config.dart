import 'game_state.dart';

/// Configuration for a territory type, including unlock thresholds and capacity multipliers
class TerritoryConfig {
  final String id;
  final String nameKey; // For localization
  final String descriptionKey; // For localization
  final TerritoryType type;
  final double threshold;
  final double capacityMultiplier;
  final double capacityBaseMultiplier;

  const TerritoryConfig({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.type,
    required this.threshold,
    required this.capacityMultiplier,
    required this.capacityBaseMultiplier,
  });

  /// Calculate the capacity for this territory based on the threshold
  double get capacity =>
      threshold * capacityMultiplier * capacityBaseMultiplier;
}

/// Configuration for all territories with their unlock thresholds
class TerritoryConfigManager {
  // Simplified constants for cleaner progression
  static const double _thousand = 1000.0;
  static const double _million = 1000000.0;
  static const double _billion = 1000000000.0;
  static const double _trillion = 1000000000000.0;

  static const List<TerritoryConfig> territoryConfigs = [
    // 1. Suburbs: Unlock at 500, Cap ~12k
    TerritoryConfig(
      id: 'suburbs',
      nameKey: 'territory.suburbs.name',
      descriptionKey: 'territory.suburbs.description',
      type: TerritoryType.suburbs,
      threshold: 500,
      capacityMultiplier: 25,
      capacityBaseMultiplier: 1,
    ),
    // 2. Urban Center: Unlock at 5k, Cap ~200k
    TerritoryConfig(
      id: 'urban_center',
      nameKey: 'territory.urban_center.name',
      descriptionKey: 'territory.urban_center.description',
      type: TerritoryType.urban,
      threshold: 5 * _thousand,
      capacityMultiplier: 40,
      capacityBaseMultiplier: 1,
    ),
     // 3. Metropolis: Unlock at 100k, Cap ~2M
    TerritoryConfig(
      id: 'metropolis',
      nameKey: 'territory.metropolis.name',
      descriptionKey: 'territory.metropolis.description',
      type: TerritoryType.metropolis,
      threshold: 100 * _thousand,
      capacityMultiplier: 20,
      capacityBaseMultiplier: 1,
    ),
    // 4. Border Town: Unlock at 1M, Cap ~10M
    TerritoryConfig(
      id: 'border_town',
      nameKey: 'territory.border_town.name',
      descriptionKey: 'territory.border_town.description',
      type: TerritoryType.border,
      threshold: 1 * _million,
      capacityMultiplier: 10,
      capacityBaseMultiplier: 1,
    ),
    // 5. Coastal Port: Unlock at 5M, Cap ~50M
    TerritoryConfig(
      id: 'coastal_port',
      nameKey: 'territory.coastal_port.name',
      descriptionKey: 'territory.coastal_port.description',
      type: TerritoryType.coastal,
      threshold: 5 * _million,
      capacityMultiplier: 10,
      capacityBaseMultiplier: 1,
    ),
    // 6. Cave Network: Unlock at 25M, Cap ~250M
    TerritoryConfig(
      id: 'cave_network',
      nameKey: 'territory.cave_network.name',
      descriptionKey: 'territory.cave_network.description',
      type: TerritoryType.caves,
      threshold: 25 * _million,
      capacityMultiplier: 10,
      capacityBaseMultiplier: 1,
    ),
    // 7. Underground City: Unlock at 100M, Cap ~1B
    TerritoryConfig(
      id: 'underground_city',
      nameKey: 'territory.underground_city.name',
      descriptionKey: 'territory.underground_city.description',
      type: TerritoryType.underground,
      threshold: 100 * _million,
      capacityMultiplier: 10,
      capacityBaseMultiplier: 1,
    ),
    // 8. Mountain Settlement: Unlock at 500M, Cap ~5B
    TerritoryConfig(
      id: 'mountain_settlement',
      nameKey: 'territory.mountain_settlement.name',
      descriptionKey: 'territory.mountain_settlement.description',
      type: TerritoryType.mountains,
      threshold: 500 * _million,
      capacityMultiplier: 10,
      capacityBaseMultiplier: 1,
    ),
    // 9. Desert Outpost: Unlock at 2.5B, Cap ~25B
    TerritoryConfig(
      id: 'desert_outpost',
      nameKey: 'territory.desert_outpost.name',
      descriptionKey: 'territory.desert_outpost.description',
      type: TerritoryType.desert,
      threshold: 2.5 * _billion,
      capacityMultiplier: 10,
      capacityBaseMultiplier: 1,
    ),
    // 10. Arctic Base: Unlock at 10B, Cap ~100B
    TerritoryConfig(
      id: 'arctic_base',
      nameKey: 'territory.arctic_base.name',
      descriptionKey: 'territory.arctic_base.description',
      type: TerritoryType.arctic,
      threshold: 10 * _billion,
      capacityMultiplier: 10,
      capacityBaseMultiplier: 1,
    ),
    // 11. Moon Colony: Unlock at 50B, Cap ~500B
    TerritoryConfig(
      id: 'moon_colony',
      nameKey: 'territory.moon_colony.name',
      descriptionKey: 'territory.moon_colony.description',
      type: TerritoryType.moon,
      threshold: 50 * _billion,
      capacityMultiplier: 10,
      capacityBaseMultiplier: 1,
    ),
    // 12. Orbital Platform: Unlock at 250B, Cap ~2.5T
    TerritoryConfig(
      id: 'orbital_platform',
      nameKey: 'territory.orbital_platform.name',
      descriptionKey: 'territory.orbital_platform.description',
      type: TerritoryType.orbital,
      threshold: 250 * _billion,
      capacityMultiplier: 10,
      capacityBaseMultiplier: 1,
    ),
    // 13. Space Station Alpha: Unlock at 1T, Cap ~10T
    TerritoryConfig(
      id: 'space_station_alpha',
      nameKey: 'territory.space_station_alpha.name',
      descriptionKey: 'territory.space_station_alpha.description',
      type: TerritoryType.spaceStation,
      threshold: 1 * _trillion,
      capacityMultiplier: 10,
      capacityBaseMultiplier: 1,
    ),
    // 14. Interstellar Ark: Unlock at 10T, Cap ~Infinity
    TerritoryConfig(
      id: 'interstellar_ark',
      nameKey: 'territory.interstellar_ark.name',
      descriptionKey: 'territory.interstellar_ark.description',
      type: TerritoryType.interstellar,
      threshold: 10 * _trillion,
      capacityMultiplier: 100,
      capacityBaseMultiplier: 1,
    ),
  ];

  /// Get all territories that should be unlocked for the given population
  static List<TerritoryConfig> getAvailableConfigs(double totalPopulation) {
    return territoryConfigs
        .where((config) => totalPopulation >= config.threshold)
        .toList();
  }

  /// Get the next territory that will be unlocked
  static TerritoryConfig? getNextUnlockConfig(double totalPopulation) {
    return territoryConfigs
        .where((config) => totalPopulation < config.threshold)
        .fold<TerritoryConfig?>(null, (next, config) {
      if (next == null || config.threshold < next.threshold) {
        return config;
      }
      return next;
    });
  }

  /// Get territory config by ID
  static TerritoryConfig? getConfigById(String id) {
    try {
      return territoryConfigs.firstWhere((config) => config.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get territory config by type
  static TerritoryConfig? getConfigByType(TerritoryType type) {
    try {
      return territoryConfigs.firstWhere((config) => config.type == type);
    } catch (e) {
      return null;
    }
  }
}
