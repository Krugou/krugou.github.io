import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_immigrants/models/game_state.dart';
import 'package:the_immigrants/models/territory_config.dart';
import 'package:the_immigrants/models/event_system.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_immigrants/providers/game_provider.dart';
import 'package:the_immigrants/utils/number_formatter.dart';
import 'mock_firebase.dart';

import 'package:the_immigrants/services/auth_service.dart';
import 'package:the_immigrants/services/database_service.dart';
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
  group('Game State Tests', () {
    test('GameState should initialize with correct default values', () {
      final gameState = GameState();

      expect(gameState.people, equals(1.0));
      expect(gameState.territories, isNotEmpty);
      expect(gameState.territories.first.id, equals('village'));
      expect(gameState.eventHistory, isEmpty);
      expect(gameState.achievedMilestones, isEmpty);
      expect(gameState.totalImmigrants, equals(1));
      expect(gameState.playTime, equals(0.0));
      expect(gameState.gameSpeed, equals(1.0));
      expect(gameState.isOnline, equals(false));
    });

    test('GameState should serialize and deserialize correctly', () {
      final originalState = GameState(
        people: 10.0,
        totalImmigrants: 10,
        playTime: 100.0,
        gameSpeed: 2.0,
        isOnline: true,
      );

      final json = originalState.toJson();
      final deserializedState = GameState.fromJson(json);

      expect(deserializedState.people, equals(originalState.people));
      expect(deserializedState.totalImmigrants, equals(originalState.totalImmigrants));
      expect(deserializedState.playTime, equals(originalState.playTime));
      expect(deserializedState.gameSpeed, equals(originalState.gameSpeed));
      expect(deserializedState.isOnline, equals(originalState.isOnline));
    });

    test('GameState should calculate total population correctly', () {
      final gameState = GameState();

      // Add some population to territories
      if (gameState.territories.isNotEmpty) {
        gameState.territories.first.population = 10.0;
      }

      expect(gameState.totalPopulation, equals(10.0));
    });
  });

  group('Territory Configuration Tests', () {
    test('Territory thresholds should be correctly defined', () {
      final configs = TerritoryConfigManager.territoryConfigs;

      expect(configs, isNotEmpty);
      expect(configs.first.id, equals('suburbs'));
      expect(configs.first.threshold, equals(500.0));
    });

    test('getAvailableConfigs should work correctly', () {
      final configs = TerritoryConfigManager.getAvailableConfigs(500.0);

      expect(configs, hasLength(1));
      expect(configs.first.id, equals('suburbs'));
    });

    test('getNextUnlockConfig should work correctly', () {
      final nextConfig = TerritoryConfigManager.getNextUnlockConfig(10.0);

      expect(nextConfig, isNotNull);
      expect(nextConfig!.id, equals('suburbs'));
    });
  });

  group('Number Formatter Tests', () {
    test('Should format numbers correctly', () {
      expect(NumberFormatter.format(123.4), equals('123.4'));
      expect(NumberFormatter.format(1234.5), equals('1.2K'));
      expect(NumberFormatter.format(1234567.8), equals('1.2M'));
      expect(NumberFormatter.format(1234567890.1), equals('1.2B'));
    });

    test('Should format time correctly', () {
      expect(NumberFormatter.formatTime(30), equals('30s'));
      expect(NumberFormatter.formatTime(90), equals('1m 30s'));
      expect(NumberFormatter.formatTime(3661), equals('1h 1m 1s'));
    });

    test('Should format percentage correctly', () {
      expect(NumberFormatter.formatPercentage(25.5), equals('25.5%'));
      expect(NumberFormatter.formatPercentage(100.0), equals('100.0%'));
    });
  });

  group('Game Provider Tests', () {
    late GameProvider gameProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      gameProvider = GameProvider(
        prefs,
        authService: MockAuthService(),
        databaseService: MockDatabaseService(),
        firebaseEventService: MockFirebaseEventService(),
      );
    });

    test('Should initialize with default game state', () {
      expect(gameProvider.gameState.people, equals(1.0));
      expect(gameProvider.gameState.totalImmigrants, equals(1));
      expect(gameProvider.gameState.gameSpeed, equals(1.0));
    });

    test('Manual immigration should work', () {
      final initialTotalImmigrants = gameProvider.gameState.totalImmigrants;

      gameProvider.manualImmigration();

      expect(gameProvider.gameState.totalImmigrants, equals(initialTotalImmigrants + 1));
    });

    test('Should be able to get recent events', () {
      final events = gameProvider.getRecentEvents(limit: 5);
      expect(events, isA<List<GameEvent>>());
    });

    test('Should be able to get territory by ID', () {
      final territory = gameProvider.getTerritory('village');
      expect(territory, isNotNull);
      expect(territory!.id, equals('village'));
    });
  });
}