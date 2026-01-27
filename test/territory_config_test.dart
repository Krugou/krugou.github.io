import 'package:flutter_test/flutter_test.dart';
import 'package:the_immigrants/models/territory_config.dart';
import 'package:the_immigrants/models/game_state.dart';
import 'package:the_immigrants/models/event_system.dart';

void main() {
  group('Territory Configuration Tests', () {
    test('Territory thresholds should match new enhanced progression', () {
      // Test the new thresholds
      const double thousand = 1000.0;
      const double million = 1000000.0;
      const double billion = 1000000000.0;
      const double trillion = 1000000000000.0;

      const expectedThresholds = {
        'suburbs': 500.0,
        'urban_center': 5 * thousand,
        'metropolis': 100 * thousand,
        'border_town': 1 * million,
        'coastal_port': 5 * million,
        'cave_network': 25 * million,
        'underground_city': 100 * million,
        'mountain_settlement': 500 * million,
        'desert_outpost': 2.5 * billion,
        'arctic_base': 10 * billion,
        'moon_colony': 50 * billion,
        'orbital_platform': 250 * billion,
        'space_station_alpha': 1 * trillion,
        'interstellar_ark': 10 * trillion,
      };

      for (final config in TerritoryConfigManager.territoryConfigs) {
        final expectedThreshold = expectedThresholds[config.id];
        expect(config.threshold, equals(expectedThreshold),
            reason: 'Threshold for ${config.id} should match new value');
      }
    });

    test('getAvailableConfigs should return territories based on population', () {
      // Test with low population
      var configs = TerritoryConfigManager.getAvailableConfigs(10.0);
      expect(configs, isEmpty);

      // Test with population >= 500 (Suburbs threshold)
      configs = TerritoryConfigManager.getAvailableConfigs(500.0);
      expect(configs, hasLength(1));
      expect(configs.first.id, equals('suburbs'));

      // Test with population >= 5000 (Urban Center threshold)
      configs = TerritoryConfigManager.getAvailableConfigs(5000.0);
      expect(configs, hasLength(2));
      expect(configs.map((c) => c.id).toList(), containsAll(['suburbs', 'urban_center']));
    });

    test('getNextUnlockConfig should return next territory to unlock', () {
      // Test with low population
      var nextConfig = TerritoryConfigManager.getNextUnlockConfig(10.0);
      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('suburbs'));

      // Test with population at Suburbs threshold
      nextConfig = TerritoryConfigManager.getNextUnlockConfig(500.0);
      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('urban_center'));

      // Test with population at Urban threshold
      nextConfig = TerritoryConfigManager.getNextUnlockConfig(5000.0);
      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('metropolis'));

      // Test with very high population (all territories unlocked)
      nextConfig = TerritoryConfigManager.getNextUnlockConfig(double.infinity);
      expect(nextConfig, isNull);
    });

    test('EventSystem.getAvailableTerritories should work with new configuration', () {
      // Test EventSystem integration
      final territories = EventSystem.getAvailableTerritories(500.0);
      expect(territories, hasLength(1));
      expect(territories.first.id, equals('suburbs'));
      expect(territories.first.type, equals(TerritoryType.suburbs));
    });

    test('Territory types should be correctly assigned', () {
      final configs = TerritoryConfigManager.territoryConfigs;

      expect(configs.firstWhere((c) => c.id == 'suburbs').type, equals(TerritoryType.suburbs));
      expect(configs.firstWhere((c) => c.id == 'urban_center').type, equals(TerritoryType.urban));
      expect(configs.firstWhere((c) => c.id == 'metropolis').type, equals(TerritoryType.metropolis));
      expect(configs.firstWhere((c) => c.id == 'border_town').type, equals(TerritoryType.border));
      expect(configs.firstWhere((c) => c.id == 'coastal_port').type, equals(TerritoryType.coastal));
      expect(configs.firstWhere((c) => c.id == 'cave_network').type, equals(TerritoryType.caves));
      expect(configs.firstWhere((c) => c.id == 'underground_city').type, equals(TerritoryType.underground));
      expect(configs.firstWhere((c) => c.id == 'mountain_settlement').type, equals(TerritoryType.mountains));
      expect(configs.firstWhere((c) => c.id == 'desert_outpost').type, equals(TerritoryType.desert));
      expect(configs.firstWhere((c) => c.id == 'arctic_base').type, equals(TerritoryType.arctic));
      expect(configs.firstWhere((c) => c.id == 'moon_colony').type, equals(TerritoryType.moon));
      expect(configs.firstWhere((c) => c.id == 'orbital_platform').type, equals(TerritoryType.orbital));
      expect(configs.firstWhere((c) => c.id == 'space_station_alpha').type, equals(TerritoryType.spaceStation));
      expect(configs.firstWhere((c) => c.id == 'interstellar_ark').type, equals(TerritoryType.interstellar));
    });

    test('All territory configs should have localization keys', () {
      for (final config in TerritoryConfigManager.territoryConfigs) {
        expect(config.nameKey, startsWith('territory.'));
        expect(config.descriptionKey, startsWith('territory.'));
        expect(config.nameKey, endsWith('.name'));
        expect(config.descriptionKey, endsWith('.description'));
      }
    });
  });
}