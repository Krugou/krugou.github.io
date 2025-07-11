import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/upgrade.dart';
import '../utils/number_formatter.dart';

class GameProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  GameState _gameState = GameState();
  Timer? _gameTimer;
  
  // Game constants
  static const double foodConsumptionRate = 0.1; // per person per second
  static const double housingConsumptionRate = 0.05; // per person per second
  static const double baseImmigrationRate = 0.02; // per second
  static const double manualFoodGain = 1.0;
  static const double immigrationFoodCost = 5.0;
  
  GameProvider(this._prefs) {
    _loadGame();
    _startGameLoop();
  }
  
  GameState get gameState => _gameState;
  
  // Game loop - runs every 100ms
  void _startGameLoop() {
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateGame(0.1); // 0.1 seconds per tick
    });
  }
  
  void _updateGame(double deltaTime) {
    // Update play time
    _gameState.playTime += deltaTime;
    
    // Calculate resource production
    double foodProduction = _gameState.farms * 2.0 * deltaTime;
    double housingProduction = _gameState.houses * 1.5 * deltaTime;
    
    // Calculate resource consumption
    double hospitalBonus = _gameState.hospitals * 0.1;
    double consumptionMultiplier = 1.0 - min(hospitalBonus, 0.5);
    
    double foodConsumption = _gameState.population * foodConsumptionRate * deltaTime * consumptionMultiplier;
    double housingConsumption = _gameState.population * housingConsumptionRate * deltaTime * consumptionMultiplier;
    
    // Update resources
    _gameState.food = max(0, _gameState.food + foodProduction - foodConsumption);
    _gameState.housing = max(0, _gameState.housing + housingProduction - housingConsumption);
    
    // Calculate happiness
    _calculateHappiness();
    
    // Handle immigration
    _handleImmigration(deltaTime);
    
    // Auto-save every 30 seconds
    if (_gameState.playTime % 30 < deltaTime) {
      _saveGame();
    }
    
    notifyListeners();
  }
  
  void _calculateHappiness() {
    // Base happiness from food and housing ratios
    double foodRatio = _gameState.population > 0 ? _gameState.food / _gameState.population : 1.0;
    double housingRatio = _gameState.population > 0 ? _gameState.housing / _gameState.population : 1.0;
    
    double baseHappiness = (foodRatio + housingRatio) * 25;
    
    // Bonus from schools
    double schoolBonus = _gameState.schools * 5.0;
    
    _gameState.happiness = min(100, max(0, baseHappiness + schoolBonus));
  }
  
  void _handleImmigration(double deltaTime) {
    // Calculate immigration rate based on happiness and ports
    double happinessMultiplier = _gameState.happiness / 50.0; // 2x rate at 100 happiness
    double portMultiplier = 1.0 + (_gameState.ports * 0.2);
    
    double immigrationRate = baseImmigrationRate * happinessMultiplier * portMultiplier;
    
    // Random chance for immigration
    double immigrationChance = immigrationRate * deltaTime;
    if (Random().nextDouble() < immigrationChance) {
      _gameState.population += 1;
      _gameState.totalImmigrants += 1;
    }
  }
  
  // Manual actions
  void gatherFood() {
    double workshopMultiplier = 1.0 + (_gameState.workshops * 0.5);
    double foodGained = manualFoodGain * workshopMultiplier;
    _gameState.food += foodGained;
    notifyListeners();
  }
  
  void manualImmigration() {
    if (_gameState.food >= immigrationFoodCost) {
      _gameState.food -= immigrationFoodCost;
      _gameState.population += 1;
      _gameState.totalImmigrants += 1;
      notifyListeners();
    }
  }
  
  // Upgrade system
  bool canAffordUpgrade(UpgradeType type) {
    final upgrade = Upgrade.allUpgrades.firstWhere((u) => u.type == type);
    int currentCount = _getUpgradeCount(type);
    double cost = upgrade.getCost(currentCount);
    return _gameState.food >= cost;
  }
  
  void buyUpgrade(UpgradeType type) {
    if (!canAffordUpgrade(type)) return;
    
    final upgrade = Upgrade.allUpgrades.firstWhere((u) => u.type == type);
    int currentCount = _getUpgradeCount(type);
    double cost = upgrade.getCost(currentCount);
    
    _gameState.food -= cost;
    _setUpgradeCount(type, currentCount + 1);
    notifyListeners();
  }
  
  int _getUpgradeCount(UpgradeType type) {
    switch (type) {
      case UpgradeType.farm:
        return _gameState.farms;
      case UpgradeType.house:
        return _gameState.houses;
      case UpgradeType.school:
        return _gameState.schools;
      case UpgradeType.hospital:
        return _gameState.hospitals;
      case UpgradeType.port:
        return _gameState.ports;
      case UpgradeType.workshop:
        return _gameState.workshops;
    }
  }
  
  void _setUpgradeCount(UpgradeType type, int count) {
    switch (type) {
      case UpgradeType.farm:
        _gameState.farms = count;
        break;
      case UpgradeType.house:
        _gameState.houses = count;
        break;
      case UpgradeType.school:
        _gameState.schools = count;
        break;
      case UpgradeType.hospital:
        _gameState.hospitals = count;
        break;
      case UpgradeType.port:
        _gameState.ports = count;
        break;
      case UpgradeType.workshop:
        _gameState.workshops = count;
        break;
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
        
        // Handle offline progress
        final now = DateTime.now();
        final timeDiff = now.difference(_gameState.lastSave);
        if (timeDiff.inSeconds > 0) {
          _updateGame(timeDiff.inSeconds.toDouble());
        }
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
    _saveGame();
    super.dispose();
  }
}