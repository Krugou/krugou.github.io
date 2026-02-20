import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_immigrants/models/game_state.dart';
import 'package:the_immigrants/models/territory_config.dart';
import 'package:the_immigrants/models/event_system.dart';
import 'package:the_immigrants/providers/game_provider.dart';
import 'package:the_immigrants/services/preferences_service.dart';
import 'package:the_immigrants/services/database_service.dart';
import 'package:the_immigrants/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'mock_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_immigrants/services/firebase_event_service.dart';

class MockFirebaseEventService implements FirebaseEventService {
  @override
  Future<bool> isFirebaseAvailable() async => false;
  @override
  Future<Map<TerritoryType, List<EventTemplate>>> loadTerritoryEvents() async => {};
  @override
  Future<List<EventTemplate>> loadMilestoneEvents() async => [];
  @override
  Future<void> addEvent(EventTemplate event, {bool isCustom = false}) async {}
  @override
  Future<void> updateEvent(EventTemplate event, {bool isCustom = false}) async {}
  @override
  Future<void> deleteEvent(String eventId, {bool isCustom = false}) async {}
  @override
  Future<List<EventTemplate>> getAllEvents() async => [];
  @override
  Future<void> uploadJsonEventsToFirebase() async {}
  @override
  Stream<List<EventTemplate>> getEventsStream() => Stream.empty();
}

class MockAuthService implements AuthService {
  @override
  User? get currentUser => null;
  @override
  Stream<User?> get authStateChanges => Stream.empty();
  @override
  Future<User?> signUp({required String email, required String password, required String displayName}) async => null;
  @override
  Future<User?> signIn({required String email, required String password}) async => null;
  @override
  Future<void> signOut() async {}
  @override
  Future<void> resetPassword({required String email}) async {}
}

class MockDatabaseService implements DatabaseService {
  @override
  Future<void> saveGameState(GameState gameState) async {}
  @override
  Future<GameState?> loadGameState() async => null;
  @override
  Future<void> saveUserProfile({required String displayName, String? bio, Map<String, dynamic>? preferences}) async {}
  @override
  Future<Map<String, dynamic>?> loadUserProfile() async => null;
  @override
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async => [];
  @override
  Future<void> updateLastActive() async {}
  @override
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {}
  @override
  Future<Map<String, dynamic>?> loadUserPreferences() async => null;
  @override
  Future<void> deleteUserData() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Integration Tests - Territory System with Localization', () {
    late SharedPreferences prefs;
    late GameProvider gameProvider;
    late PreferencesService preferencesService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      final mockDatabase = MockDatabaseService();

      gameProvider = GameProvider(
        prefs,
        authService: MockAuthService(),
        databaseService: mockDatabase,
        firebaseEventService: MockFirebaseEventService(),
      );
      preferencesService = PreferencesService(prefs, mockDatabase);
    });

    test('Territory unlock progression should work correctly', () async {
      // Initialize with low population
      expect(gameProvider.gameState.totalPopulation, lessThan(25.0));

      // No territories should be unlocked except the initial village
      expect(gameProvider.gameState.territories.length, equals(1));
      expect(gameProvider.gameState.territories.first.id, equals('village'));

      // Manually add population to reach suburbs threshold (500)
      gameProvider.gameState.territories.first.population = 500.0;

      // Check that territory unlock logic works
      final availableTerritories = EventSystem.getAvailableTerritories(500.0);
      expect(availableTerritories.length, equals(1));
      expect(availableTerritories.first.id, equals('suburbs'));
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
        500.0, // suburbs
        5000.0, // urban_center
        100000.0, // metropolis
        1000000.0, // border_town
        5000000.0, // coastal_port
        25000000.0, // cave_network
        100000000.0, // underground_city
        500000000.0, // mountain_settlement
        2500000000.0, // desert_outpost
        10000000000.0, // arctic_base
        50000000000.0, // moon_colony
        250000000000.0, // orbital_platform
        1000000000000.0, // space_station_alpha
        10000000000000.0, // interstellar_ark
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
      expect(nextConfig!.id, equals('suburbs'));
      expect(nextConfig.threshold, equals(500.0));

      // Test with population at suburbs threshold
      nextConfig = TerritoryConfigManager.getNextUnlockConfig(500.0);
      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('urban_center'));
      expect(nextConfig.threshold, equals(5000.0));

      // Test with population at urban center threshold
      nextConfig = TerritoryConfigManager.getNextUnlockConfig(5000.0);
      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('metropolis'));
      expect(nextConfig.threshold, equals(100000.0));
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