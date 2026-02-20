import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/game_state.dart';
import '../models/event_system.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/firebase_event_service.dart';


class GameProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  GameState _gameState = GameState();
  Timer? _gameTimer;
  Timer? _eventTimer;
  Timer? _cloudSyncTimer;

  // Firebase services
  final AuthService _authService;
  final DatabaseService _databaseService;
  final FirebaseEventService? _firebaseEventService;

  // Authentication state
  User? _currentUser;
  bool _isAuthenticated = false;
  String? _authError;

  // Game constants
  static const double eventCheckInterval =
      5.0; // Check for events every 5 seconds
  static const double baseEventProbability = 0.3; // 30% chance per check
  static const double cloudSyncInterval =
      30.0; // Sync with cloud every 30 seconds

  GameProvider(this._prefs, {
    AuthService? authService,
    DatabaseService? databaseService,
    FirebaseEventService? firebaseEventService,
  }) : _authService = authService ?? AuthService(),
       _databaseService = databaseService ?? DatabaseService(),
       _firebaseEventService = firebaseEventService {
    _initializeEventSystem();
    _initializeAuthListener();
    _loadGame();
    _startGameLoop();
    _startEventSystem();
  }

  // Sync game speed with preferences
  void syncWithPreferences(double gameSpeed) {
    if (_gameState.gameSpeed != gameSpeed) {
      updateGameSpeed(gameSpeed);
    }
  }

  // Getters
  GameState get gameState => _gameState;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String? get authError => _authError;

  // Initialize event system
  Future<void> _initializeEventSystem() async {
    try {
      await EventSystem.initialize(firebaseService: _firebaseEventService);
    } catch (e) {
      print('Error initializing event system: $e');
    }
  }

  // Initialize authentication listener
  void _initializeAuthListener() {
    _authService.authStateChanges.listen((User? user) {
      _currentUser = user;
      _isAuthenticated = user != null;
      _gameState.userId = user?.uid;
      _gameState.isOnline = _isAuthenticated;

      if (_isAuthenticated) {
        _startCloudSync();
        _loadCloudGameState();
      } else {
        _stopCloudSync();
      }

      notifyListeners();
    });
  }

  // Authentication methods
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      _authError = null;
      final user = await _authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (user != null) {
        // Create user profile
        await _databaseService.saveUserProfile(
          displayName: displayName,
          preferences: {
            'theme': 'default',
            'notifications': true,
          },
        );

        // Save current game state to cloud
        await _saveCloudGameState();
      }
    } catch (e) {
      _authError = e.toString();
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _authError = null;
      await _authService.signIn(email: email, password: password);
    } catch (e) {
      _authError = e.toString();
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      _authError = null;
      await _authService.resetPassword(email: email);
    } catch (e) {
      _authError = e.toString();
      notifyListeners();
    }
  }

  // Cloud sync methods
  void _startCloudSync() {
    _cloudSyncTimer = Timer.periodic(
      Duration(seconds: cloudSyncInterval.toInt()),
      (timer) => _saveCloudGameState(),
    );
  }

  void _stopCloudSync() {
    _cloudSyncTimer?.cancel();
    _cloudSyncTimer = null;
  }

  Future<void> _saveCloudGameState() async {
    if (!_isAuthenticated) return;

    try {
      await _databaseService.saveGameState(_gameState);
    } catch (e) {
      print('Error saving to cloud: $e');
    }
  }

  Future<void> _loadCloudGameState() async {
    if (!_isAuthenticated) return;

    try {
      final cloudGameState = await _databaseService.loadGameState();
      if (cloudGameState != null) {
        // Merge with local state (use the one with more recent timestamp)
        if (cloudGameState.lastSave.isAfter(_gameState.lastSave)) {
          _gameState = cloudGameState;
          notifyListeners();
        } else {
          // Local state is newer, save it to cloud
          await _saveCloudGameState();
        }
      }
    } catch (e) {
      print('Error loading from cloud: $e');
    }
  }

  // Game loop - runs every second for basic updates
  void _startGameLoop() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateGame(1.0); // 1 second per tick
    });
  }

  // Event system - checks for events periodically
  void _startEventSystem() {
    _eventTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkForEvents();
    });
  }

  // Update game speed based on preferences
  void updateGameSpeed(double speed) {
    _gameState.gameSpeed = speed;

    // Restart timers with new speed
    _gameTimer?.cancel();
    _eventTimer?.cancel();

    // Apply speed multiplier to intervals
    final gameInterval = Duration(milliseconds: (1000 / speed).round());
    final eventInterval = Duration(milliseconds: (5000 / speed).round());

    _gameTimer = Timer.periodic(gameInterval, (timer) {
      _updateGame(speed); // Pass speed as delta time multiplier
    });

    _eventTimer = Timer.periodic(eventInterval, (timer) {
      _checkForEvents();
    });

    notifyListeners();
  }

  void _updateGame(double deltaTime) {
    // Update play time
    _gameState.playTime += deltaTime;

    // Check for territory unlocks
    _checkTerritoryUnlocks();

    // Auto-save every 30 seconds
    if (_gameState.playTime % 30 < deltaTime) {
      _saveGame();
    }

    notifyListeners();
  }

  void _checkForEvents() {
    // Generate events for each territory
    for (final territory in _gameState.territories) {
      if (territory.isUnlocked) {
        final event = EventSystem.generateEvent(territory);
        if (event != null) {
          _processEvent(event);
        }
      }
    }

    // Check for milestone events
    final totalPopulation = _gameState.totalPopulation;
    final milestoneEvent = EventSystem.checkMilestoneEvent(
      totalPopulation,
      _gameState.achievedMilestones,
    );
    if (milestoneEvent != null) {
      _processEvent(milestoneEvent);

      // Add to achieved milestones
      if (!_gameState.achievedMilestones.contains(milestoneEvent.id)) {
        _gameState.achievedMilestones.add(milestoneEvent.id);
      }
    }
  }

  void _processEvent(GameEvent event) {
    // Add event to history
    _gameState.eventHistory.add(event);

    // Keep only last 50 events for memory management
    if (_gameState.eventHistory.length > 50) {
      _gameState.eventHistory.removeAt(0);
    }

    // Apply population change
    if (event.targetTerritoryId != null) {
      // Apply to specific territory
      final territory = _gameState.territories.firstWhere(
        (t) => t.id == event.targetTerritoryId,
        orElse: () => _gameState.territories.first,
      );

      territory.population = (territory.population + event.populationChange)
          .clamp(0, territory.capacity);
    } else {
      // Apply to total population (milestone events)
      _gameState.people = (_gameState.people + event.populationChange)
          .clamp(0, double.infinity);
    }

    // Update total immigrants count
    if (event.populationChange > 0) {
      _gameState.totalImmigrants += event.populationChange.toInt();
    }

    notifyListeners();
  }

  void _checkTerritoryUnlocks() {
    final totalPopulation = _gameState.totalPopulation;
    final availableTerritories =
        EventSystem.getAvailableTerritories(totalPopulation);

    for (final territory in availableTerritories) {
      // Check if territory is already unlocked
      final exists = _gameState.territories.any((t) => t.id == territory.id);
      if (!exists) {
        territory.isUnlocked = true;
        _gameState.territories.add(territory);

        // Create a territory unlock event
        final unlockEvent = GameEvent(
          id: 'unlock_${territory.id}_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Territory Unlocked',
          description: 'New territory available: ${territory.name}',
          type: EventType.milestone,
          populationChange: 0,
          targetTerritoryId: territory.id,
          category: 'milestone',
        );

        _processEvent(unlockEvent);
      }
    }
  }

  // Manual immigration action
  void manualImmigration() {
    // Add a person to the first available territory with capacity
    final availableTerritory = _gameState.territories.firstWhere(
      (t) => t.isUnlocked && t.population < t.capacity,
      orElse: () => _gameState.territories.first,
    );
// TODO: make this more robust by checking if any territory is available
    // Calculate immigration amount based on current population
    final immigrationAmount =
        (_gameState.totalPopulation * 0.01).ceil().clamp(1, 1000000);

    // Create manual immigration event
    final manualEvent = GameEvent(
      id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Manual Immigration',
      description:
          'You helped $immigrationAmount new immigrants settle in ${availableTerritory.name}',
      type: EventType.immigration,
      populationChange: immigrationAmount.toDouble(),
      targetTerritoryId: availableTerritory.id,
      category: 'opportunity',
    );

    _processEvent(manualEvent);
  }

  // Get recent events for display
  List<GameEvent> getRecentEvents({int limit = 10}) {
    return _gameState.eventHistory.reversed.take(limit).toList();
  }

  // Get events by category
  List<GameEvent> getEventsByCategory(String category, {int limit = 10}) {
    return _gameState.eventHistory
        .where((event) => event.category == category)
        .toList()
        .reversed
        .take(limit)
        .toList();
  }

  // Get territory by ID
  Territory? getTerritory(String id) {
    try {
      return _gameState.territories.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    if (!_isAuthenticated) return [];

    try {
      return await _databaseService.getLeaderboard();
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }

  // Save/Load functionality
  void _saveGame() {
    final gameData = jsonEncode(_gameState.toJson());
    _prefs.setString('game_save', gameData);
  }

  void _loadGame() {
    final saveData = _prefs.getString('game_save');
    if (saveData != null) {
      try {
        final gameData = jsonDecode(saveData);
        _gameState = GameState.fromJson(gameData);

        // Handle offline progress - simulate some events
        final now = DateTime.now();
        final timeDiff = now.difference(_gameState.lastSave);
        final hoursOffline = timeDiff.inHours;

        if (hoursOffline > 0) {
          // Simulate offline events (simplified)
          final offlineEvents = min(hoursOffline, 10); // Max 10 events
          for (int i = 0; i < offlineEvents; i++) {
            for (final territory in _gameState.territories) {
              if (territory.isUnlocked) {
                final event = EventSystem.generateEvent(territory);
                if (event != null) {
                  _processEvent(event);
                }
              }
            }
          }
        }

        _gameState.lastSave = now;
      } catch (e) {
        // If loading fails, start with default state
        _gameState = GameState();
      }
    }
  }

  void resetGame() {
    _gameState = GameState();
    _prefs.remove('game_save');
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _eventTimer?.cancel();
    _cloudSyncTimer?.cancel();
    _saveGame();
    super.dispose();
  }
}
