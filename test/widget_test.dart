import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_immigrants/models/game_state.dart';
import 'package:the_immigrants/models/upgrade.dart';
import 'package:the_immigrants/providers/game_provider.dart';
import 'package:the_immigrants/utils/number_formatter.dart';

void main() {
  group('Game State Tests', () {
    test('GameState should initialize with correct default values', () {
      final gameState = GameState();
      
      expect(gameState.population, equals(1.0));
      expect(gameState.food, equals(10.0));
      expect(gameState.housing, equals(5.0));
      expect(gameState.happiness, equals(50.0));
      expect(gameState.totalImmigrants, equals(1));
      expect(gameState.farms, equals(0));
      expect(gameState.houses, equals(0));
    });
    
    test('GameState should serialize and deserialize correctly', () {
      final originalState = GameState(
        population: 10.0,
        food: 100.0,
        housing: 50.0,
        happiness: 75.0,
        farms: 5,
        houses: 3,
        totalImmigrants: 10,
      );
      
      final json = originalState.toJson();
      final deserializedState = GameState.fromJson(json);
      
      expect(deserializedState.population, equals(originalState.population));
      expect(deserializedState.food, equals(originalState.food));
      expect(deserializedState.housing, equals(originalState.housing));
      expect(deserializedState.happiness, equals(originalState.happiness));
      expect(deserializedState.farms, equals(originalState.farms));
      expect(deserializedState.houses, equals(originalState.houses));
      expect(deserializedState.totalImmigrants, equals(originalState.totalImmigrants));
    });
  });
  
  group('Upgrade Tests', () {
    test('Upgrade cost should increase with count', () {
      final farmUpgrade = Upgrade.allUpgrades.firstWhere((u) => u.type == UpgradeType.farm);
      
      expect(farmUpgrade.getCost(0), equals(50.0));
      expect(farmUpgrade.getCost(1), equals(50.0 * 1.15));
      expect(farmUpgrade.getCost(2), equals(50.0 * 1.15 * 2));
    });
    
    test('All upgrades should have correct properties', () {
      expect(Upgrade.allUpgrades.length, equals(6));
      
      final farmUpgrade = Upgrade.allUpgrades.firstWhere((u) => u.type == UpgradeType.farm);
      expect(farmUpgrade.name, equals('Community Farm'));
      expect(farmUpgrade.getBenefit(), equals('+2 food/sec'));
      
      final houseUpgrade = Upgrade.allUpgrades.firstWhere((u) => u.type == UpgradeType.house);
      expect(houseUpgrade.name, equals('Housing Complex'));
      expect(houseUpgrade.getBenefit(), equals('+1.5 housing/sec'));
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
      gameProvider = GameProvider(prefs);
    });
    
    test('Should initialize with default game state', () {
      expect(gameProvider.gameState.population, equals(1.0));
      expect(gameProvider.gameState.food, equals(10.0));
    });
    
    test('Manual food gathering should work', () {
      final initialFood = gameProvider.gameState.food;
      gameProvider.gatherFood();
      expect(gameProvider.gameState.food, greaterThan(initialFood));
    });
    
    test('Manual immigration should work when affordable', () {
      // Ensure we have enough food
      gameProvider.gameState.food = 100.0;
      final initialPopulation = gameProvider.gameState.population;
      
      gameProvider.manualImmigration();
      
      expect(gameProvider.gameState.population, equals(initialPopulation + 1));
      expect(gameProvider.gameState.food, equals(95.0)); // 100 - 5 cost
    });
    
    test('Manual immigration should not work when not affordable', () {
      // Set food below cost
      gameProvider.gameState.food = 3.0;
      final initialPopulation = gameProvider.gameState.population;
      final initialFood = gameProvider.gameState.food;
      
      gameProvider.manualImmigration();
      
      expect(gameProvider.gameState.population, equals(initialPopulation));
      expect(gameProvider.gameState.food, equals(initialFood));
    });
    
    test('Should be able to buy upgrades when affordable', () {
      // Set enough food for a farm
      gameProvider.gameState.food = 100.0;
      final initialFarms = gameProvider.gameState.farms;
      
      expect(gameProvider.canAffordUpgrade(UpgradeType.farm), isTrue);
      
      gameProvider.buyUpgrade(UpgradeType.farm);
      
      expect(gameProvider.gameState.farms, equals(initialFarms + 1));
      expect(gameProvider.gameState.food, equals(50.0)); // 100 - 50 cost
    });
    
    test('Should not be able to buy upgrades when not affordable', () {
      // Set food below cost
      gameProvider.gameState.food = 10.0;
      final initialFarms = gameProvider.gameState.farms;
      final initialFood = gameProvider.gameState.food;
      
      expect(gameProvider.canAffordUpgrade(UpgradeType.farm), isFalse);
      
      gameProvider.buyUpgrade(UpgradeType.farm);
      
      expect(gameProvider.gameState.farms, equals(initialFarms));
      expect(gameProvider.gameState.food, equals(initialFood));
    });
  });
}