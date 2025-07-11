import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/event_system.dart';
import '../utils/number_formatter.dart';

class GameProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  GameState _gameState = GameState();
  Timer? _gameTimer;
  Timer? _eventTimer;
  
  // Game constants
  static const double eventCheckInterval = 5.0; // Check for events every 5 seconds
  static const double baseEventProbability = 0.3; // 30% chance per check
  
  GameProvider(this._prefs) {
    _loadGame();
    _startGameLoop();
    _startEventSystem();
  }
  
  GameState get gameState => _gameState;
  
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
    final milestoneEvent = EventSystem.checkMilestoneEvent(totalPopulation);
    if (milestoneEvent != null) {
      _processEvent(milestoneEvent);
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
      
      territory.population = (territory.population + event.populationChange).clamp(0, territory.capacity);
    } else {
      // Apply to total population (milestone events)
      _gameState.people = (_gameState.people + event.populationChange).clamp(0, double.infinity);
    }
    
    // Update total immigrants count
    if (event.populationChange > 0) {
      _gameState.totalImmigrants += event.populationChange.toInt();
    }
    
    notifyListeners();
  }
  
  void _checkTerritoryUnlocks() {
    final totalPopulation = _gameState.totalPopulation;
    final availableTerritories = EventSystem.getAvailableTerritories(totalPopulation);
    
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
    
    availableTerritory.population += 1;
    _gameState.totalImmigrants += 1;
    
    // Create manual immigration event
    final manualEvent = GameEvent(
      id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Manual Immigration',
      description: 'You helped a new immigrant settle in ${availableTerritory.name}',
      type: EventType.immigration,
      populationChange: 1,
      targetTerritoryId: availableTerritory.id,
    );
    
    _processEvent(manualEvent);
  }
  
  // Get recent events for display
  List<GameEvent> getRecentEvents({int limit = 10}) {
    return _gameState.eventHistory.reversed.take(limit).toList();
  }
  
  // Get territory by ID
  Territory? getTerritory(String id) {
    try {
      return _gameState.territories.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
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
    _saveGame();
    super.dispose();
  }
}