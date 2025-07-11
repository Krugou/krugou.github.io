import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_immigrants/models/game_state.dart';
import 'package:the_immigrants/models/territory_config.dart';
import 'package:the_immigrants/models/event_system.dart';
import 'package:the_immigrants/providers/game_provider.dart';
import 'package:the_immigrants/services/preferences_service.dart';
import 'package:the_immigrants/services/database_service.dart';
import 'package:flutter/material.dart';

void main() {
  group('Integration Tests - Territory System with Localization', () {
    late SharedPreferences prefs;
    late GameProvider gameProvider;
    late PreferencesService preferencesService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      gameProvider = GameProvider(prefs);
      preferencesService = PreferencesService(prefs, DatabaseService());
    });

    test('Territory unlock progression should work correctly', () async {
      // Initialize with low population
      expect(gameProvider.gameState.totalPopulation, lessThan(25.0));
      
      // No territories should be unlocked except the initial village
      expect(gameProvider.gameState.territories.length, equals(1));
      expect(gameProvider.gameState.territories.first.id, equals('village'));
      
      // Manually add population to reach urban center threshold
      gameProvider.gameState.territories.first.population = 25.0;
      
      // Check that territory unlock logic works
      final availableTerritories = EventSystem.getAvailableTerritories(25.0);
      expect(availableTerritories.length, equals(1));
      expect(availableTerritories.first.id, equals('urban_center'));
    });

    test('Game speed functionality should work correctly', () async {
      // Initial game speed should be 1.0
      expect(gameProvider.gameState.gameSpeed, equals(1.0));
      
      // Update game speed via preferences
      await preferencesService.updateGameSpeed(2.0);
      expect(preferencesService.gameSpeed, equals(2.0));
      
      // Sync game provider with preferences
      gameProvider.syncWithPreferences(preferencesService.gameSpeed);
      expect(gameProvider.gameState.gameSpeed, equals(2.0));
    });

    test('Language preferences should work correctly', () async {
      // Initial locale should be English
      expect(preferencesService.locale, equals(const Locale('en')));
      
      // Update to Finnish
      await preferencesService.updateLocale(const Locale('fi'));
      expect(preferencesService.locale, equals(const Locale('fi')));
      
      // Update back to English
      await preferencesService.updateLocale(const Locale('en'));
      expect(preferencesService.locale, equals(const Locale('en')));
    });

    test('Territory configuration should maintain original thresholds', () {
      // Test that the new configuration system produces the same results as the original
      final originalThresholds = [
        25.0, // urban_center
        100000.0, // border_town
        300000000.0, // coastal_port
        1200000000000.0, // cave_network
        1440000000000000.0, // underground_city
        2160000000000000000.0, // mountain_settlement
        4320000000000000000000.0, // desert_outpost
        12960000000000000000000000.0, // arctic_base
        25920000000000000000000000000.0, // orbital_platform
        51840000000000000000000000000000.0, // space_station_alpha
      ];

      final configs = TerritoryConfigManager.territoryConfigs;
      expect(configs.length, equals(originalThresholds.length));
      
      for (int i = 0; i < configs.length; i++) {
        expect(configs[i].threshold, equals(originalThresholds[i]),
            reason: 'Threshold for ${configs[i].id} should match original');
      }
    });

    test('Next unlock information should be dynamic', () {
      // Test with population below first threshold
      var nextConfig = TerritoryConfigManager.getNextUnlockConfig(10.0);
      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('urban_center'));
      expect(nextConfig.threshold, equals(25.0));
      
      // Test with population at urban center threshold
      nextConfig = TerritoryConfigManager.getNextUnlockConfig(25.0);
      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('border_town'));
      expect(nextConfig.threshold, equals(100000.0));
      
      // Test with population at border town threshold
      nextConfig = TerritoryConfigManager.getNextUnlockConfig(100000.0);
      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('coastal_port'));
      expect(nextConfig.threshold, equals(300000000.0));
    });

    test('Game state serialization should include new fields', () {
      // Set some values
      gameProvider.gameState.gameSpeed = 2.0;
      gameProvider.gameState.people = 100.0;
      
      // Serialize and deserialize
      final json = gameProvider.gameState.toJson();
      final newState = GameState.fromJson(json);
      
      // Check that new fields are preserved
      expect(newState.gameSpeed, equals(2.0));
      expect(newState.people, equals(100.0));
    });

    test('Event system integration should work with new territories', () {
      // Test that event system can generate events for new territory types
      final mountainTerritory = Territory(
        id: 'mountain_settlement',
        name: 'Mountain Settlement',
        description: 'High-altitude community',
        type: TerritoryType.mountains,
        population: 10.0,
        capacity: 1000.0,
        isUnlocked: true,
      );
      
      // Generate events for mountain territory
      final event = EventSystem.generateEvent(mountainTerritory);
      // Event generation is random, so it might be null
      // But the system should not crash
      expect(event, anyOf(isNull, isA<GameEvent>()));
    });

    test('Preferences service should handle errors gracefully', () async {
      // Test with invalid game speed
      expect(() async => await preferencesService.updateGameSpeed(-1.0), 
          throwsArgumentError);
      
      // Test with unsupported locale
      expect(() async => await preferencesService.updateLocale(const Locale('xx')), 
          throwsArgumentError);
    });

    test('Manual immigration should work with new territory system', () {
      final initialPopulation = gameProvider.gameState.totalPopulation;
      final initialImmigrants = gameProvider.gameState.totalImmigrants;
      
      // Call manual immigration
      gameProvider.manualImmigration();
      
      // Check that population increased
      expect(gameProvider.gameState.totalPopulation, greaterThan(initialPopulation));
      expect(gameProvider.gameState.totalImmigrants, equals(initialImmigrants + 1));
      
      // Check that event was created
      final events = gameProvider.getRecentEvents(limit: 1);
      expect(events, isNotEmpty);
      expect(events.first.type, equals(EventType.immigration));
    });
  });

  group('Performance Tests', () {
    test('Territory configuration lookup should be efficient', () {
      // Test that lookups are fast even with many territories
      const int iterations = 1000;
      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < iterations; i++) {
        TerritoryConfigManager.getAvailableConfigs(100000.0);
        TerritoryConfigManager.getNextUnlockConfig(50000.0);
        TerritoryConfigManager.getConfigById('urban_center');
      }
      
      stopwatch.stop();
      
      // Should complete quickly (less than 1 second)
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}