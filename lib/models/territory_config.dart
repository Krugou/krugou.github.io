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
  static const double _capacityMultiplier = 1000.0;
  static const double _urbanThreshold = 25.0;
  static const double _nextTerritoryThresholdMultiplier = 0.6;

  // Calculate thresholds based on the original formula to maintain exact same numbers
  static const double _borderThreshold = _urbanThreshold *
      4 *
      _capacityMultiplier *
      _nextTerritoryThresholdMultiplier; // 100,000
  static const double _coastalThreshold = _borderThreshold *
      3 *
      _capacityMultiplier *
      _nextTerritoryThresholdMultiplier; // 300,000,000
  static const double _caveThreshold = _coastalThreshold *
      4 *
      _capacityMultiplier *
      _nextTerritoryThresholdMultiplier; // 1,200,000,000,000
  static const double _undergroundThreshold =
      _caveThreshold * 1.2 * _capacityMultiplier; // 1,440,000,000,000,000
  static const double _mountainThreshold = _undergroundThreshold *
      1.5 *
      _nextTerritoryThresholdMultiplier *
      _capacityMultiplier; // 2,160,000,000,000,000,000
  static const double _desertThreshold = _mountainThreshold *
      2 *
      _capacityMultiplier *
      _nextTerritoryThresholdMultiplier; // 4,320,000,000,000,000,000,000
  static const double _arcticThreshold = _desertThreshold *
      3 *
      _capacityMultiplier *
      _nextTerritoryThresholdMultiplier; // 12,960,000,000,000,000,000,000,000
  static const double _orbitalThreshold = _arcticThreshold *
      2 *
      _capacityMultiplier *
      _nextTerritoryThresholdMultiplier; // 25,920,000,000,000,000,000,000,000,000
  static const double _spaceStationThreshold = _orbitalThreshold *
      2 *
      _capacityMultiplier *
      _nextTerritoryThresholdMultiplier; // 51,840,000,000,000,000,000,000,000,000,000

  static const List<TerritoryConfig> territoryConfigs = [
    TerritoryConfig(
      id: 'urban_center',
      nameKey: 'territory.urban_center.name',
      descriptionKey: 'territory.urban_center.description',
      type: TerritoryType.urban,
      threshold: _urbanThreshold,
      capacityMultiplier: 4,
      capacityBaseMultiplier: _capacityMultiplier,
    ),
    TerritoryConfig(
      id: 'border_town',
      nameKey: 'territory.border_town.name',
      descriptionKey: 'territory.border_town.description',
      type: TerritoryType.border,
      threshold: _borderThreshold,
      capacityMultiplier: 3,
      capacityBaseMultiplier: _capacityMultiplier,
    ),
    TerritoryConfig(
      id: 'coastal_port',
      nameKey: 'territory.coastal_port.name',
      descriptionKey: 'territory.coastal_port.description',
      type: TerritoryType.coastal,
      threshold: _coastalThreshold,
      capacityMultiplier: 4,
      capacityBaseMultiplier: _capacityMultiplier,
    ),
    TerritoryConfig(
      id: 'cave_network',
      nameKey: 'territory.cave_network.name',
      descriptionKey: 'territory.cave_network.description',
      type: TerritoryType.caves,
      threshold: _caveThreshold,
      capacityMultiplier: 1.2,
      capacityBaseMultiplier: _capacityMultiplier,
    ),
    TerritoryConfig(
      id: 'underground_city',
      nameKey: 'territory.underground_city.name',
      descriptionKey: 'territory.underground_city.description',
      type: TerritoryType.underground,
      threshold: _undergroundThreshold,
      capacityMultiplier: 1.5,
      capacityBaseMultiplier: _capacityMultiplier,
    ),
    TerritoryConfig(
      id: 'mountain_settlement',
      nameKey: 'territory.mountain_settlement.name',
      descriptionKey: 'territory.mountain_settlement.description',
      type: TerritoryType.mountains,
      threshold: _mountainThreshold,
      capacityMultiplier: 2,
      capacityBaseMultiplier: _capacityMultiplier,
    ),
    TerritoryConfig(
      id: 'desert_outpost',
      nameKey: 'territory.desert_outpost.name',
      descriptionKey: 'territory.desert_outpost.description',
      type: TerritoryType.desert,
      threshold: _desertThreshold,
      capacityMultiplier: 3,
      capacityBaseMultiplier: _capacityMultiplier,
    ),
    TerritoryConfig(
      id: 'arctic_base',
      nameKey: 'territory.arctic_base.name',
      descriptionKey: 'territory.arctic_base.description',
      type: TerritoryType.arctic,
      threshold: _arcticThreshold,
      capacityMultiplier: 2,
      capacityBaseMultiplier: _capacityMultiplier,
    ),
    TerritoryConfig(
      id: 'orbital_platform',
      nameKey: 'territory.orbital_platform.name',
      descriptionKey: 'territory.orbital_platform.description',
      type: TerritoryType.orbital,
      threshold: _orbitalThreshold,
      capacityMultiplier: 2,
      capacityBaseMultiplier: _capacityMultiplier,
    ),
    TerritoryConfig(
      id: 'space_station_alpha',
      nameKey: 'territory.space_station_alpha.name',
      descriptionKey: 'territory.space_station_alpha.description',
      type: TerritoryType.spaceStation,
      threshold: _spaceStationThreshold,
      capacityMultiplier: 4,
      capacityBaseMultiplier: _capacityMultiplier,
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
