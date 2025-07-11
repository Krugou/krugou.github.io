import 'package:flutter_test/flutter_test.dart';
import 'package:the_immigrants/models/territory_config.dart';
import 'package:the_immigrants/models/game_state.dart';
import 'package:the_immigrants/models/event_system.dart';

void main() {
  group('Territory Configuration Tests', () {
    test('Territory thresholds should maintain exact same values', () {
      // Test the exact thresholds from the original implementation
      const expectedThresholds = {
        'urban_center': 25.0,
        'border_town': 100000.0, // 25 * 4 * 1000
        'coastal_port': 300000000.0, // 100000 * 3 * 1000
        'cave_network': 1200000000000.0, // 300000000 * 4 * 1000
        'underground_city': 1440000000000000.0, // 1200000000000 * 1.2 * 1000
        'mountain_settlement': 2160000000000000000.0, // 1440000000000000 * 1.5 * 1000
        'desert_outpost': 4320000000000000000000.0, // 2160000000000000000 * 2 * 1000
        'arctic_base': 12960000000000000000000000.0, // 4320000000000000000000 * 3 * 1000
        'orbital_platform': 25920000000000000000000000000.0, // 12960000000000000000000000 * 2 * 1000
        'space_station_alpha': 51840000000000000000000000000000.0, // 25920000000000000000000000000 * 2 * 1000
      };

      for (final config in TerritoryConfigManager.territoryConfigs) {
        final expectedThreshold = expectedThresholds[config.id];
        expect(config.threshold, equals(expectedThreshold), 
            reason: 'Threshold for ${config.id} should match original value');
      }
    });

    test('Territory capacities should match original calculations', () {
      // Test capacity calculations
      const capacityMultiplier = 1000.0;
      
      final urbanConfig = TerritoryConfigManager.getConfigById('urban_center');
      expect(urbanConfig, isNotNull);
      expect(urbanConfig!.capacity, equals(25.0 * 4 * capacityMultiplier));
      
      final borderConfig = TerritoryConfigManager.getConfigById('border_town');
      expect(borderConfig, isNotNull);
      expect(borderConfig!.capacity, equals(100000.0 * 3 * capacityMultiplier));
    });

    test('getAvailableConfigs should return territories based on population', () {
      // Test with low population
      var configs = TerritoryConfigManager.getAvailableConfigs(10.0);
      expect(configs, isEmpty);
      
      // Test with population >= 25 (urban center threshold)
      configs = TerritoryConfigManager.getAvailableConfigs(25.0);
      expect(configs, hasLength(1));
      expect(configs.first.id, equals('urban_center'));
      
      // Test with population >= 100000 (border town threshold)
      configs = TerritoryConfigManager.getAvailableConfigs(100000.0);
      expect(configs, hasLength(2));
      expect(configs.map((c) => c.id).toList(), containsAll(['urban_center', 'border_town']));
    });

    test('getNextUnlockConfig should return next territory to unlock', () {
      // Test with low population
      var nextConfig = TerritoryConfigManager.getNextUnlockConfig(10.0);
      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('urban_center'));
      
      // Test with population at urban center threshold
      nextConfig = TerritoryConfigManager.getNextUnlockConfig(25.0);
      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('border_town'));
      
      // Test with very high population (all territories unlocked)
      nextConfig = TerritoryConfigManager.getNextUnlockConfig(double.infinity);
      expect(nextConfig, isNull);
    });

    test('EventSystem.getAvailableTerritories should work with new configuration', () {
      // Test EventSystem integration
      final territories = EventSystem.getAvailableTerritories(25.0);
      expect(territories, hasLength(1));
      expect(territories.first.id, equals('urban_center'));
      expect(territories.first.type, equals(TerritoryType.urban));
    });

    test('Territory types should be correctly assigned', () {
      final configs = TerritoryConfigManager.territoryConfigs;
      
      expect(configs.firstWhere((c) => c.id == 'urban_center').type, equals(TerritoryType.urban));
      expect(configs.firstWhere((c) => c.id == 'border_town').type, equals(TerritoryType.border));
      expect(configs.firstWhere((c) => c.id == 'coastal_port').type, equals(TerritoryType.coastal));
      expect(configs.firstWhere((c) => c.id == 'cave_network').type, equals(TerritoryType.caves));
      expect(configs.firstWhere((c) => c.id == 'underground_city').type, equals(TerritoryType.underground));
      expect(configs.firstWhere((c) => c.id == 'mountain_settlement').type, equals(TerritoryType.mountains));
      expect(configs.firstWhere((c) => c.id == 'desert_outpost').type, equals(TerritoryType.desert));
      expect(configs.firstWhere((c) => c.id == 'arctic_base').type, equals(TerritoryType.arctic));
      expect(configs.firstWhere((c) => c.id == 'orbital_platform').type, equals(TerritoryType.orbital));
      expect(configs.firstWhere((c) => c.id == 'space_station_alpha').type, equals(TerritoryType.spaceStation));
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