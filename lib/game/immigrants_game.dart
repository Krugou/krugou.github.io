import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ImmigrantsGame extends FlameGame with HasTapDetector {
  late TextComponent populationText;
  late TextComponent eventText;
  
  // Game state callback
  void Function(String eventType)? onGameEvent;
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Initialize text components
    populationText = TextComponent(
      text: 'Population: 1',
      position: Vector2(20, 50),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    eventText = TextComponent(
      text: 'Welcome to your new community!',
      position: Vector2(20, 100),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
    );
    
    // Add components to the game
    add(populationText);
    add(eventText);
    
    // Add a simple background
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.green.shade800,
    ));
  }
  
  @override
  bool onTapDown(TapDownInfo info) {
    // Trigger a manual event when tapped
    onGameEvent?.call('manual_immigration');
    return true;
  }
  
  // Update population display
  void updatePopulation(double population) {
    populationText.text = 'Population: ${population.toInt()}';
  }
  
  // Update event display
  void updateEvent(String eventMessage) {
    eventText.text = eventMessage;
  }
  
  // Add visual effects for territory expansion
  void showTerritoryUnlock(String territoryName) {
    final unlockText = TextComponent(
      text: 'New Territory Unlocked: $territoryName',
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.yellow,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    add(unlockText);
    
    // Remove the text after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      unlockText.removeFromParent();
    });
  }
  
  // Add visual effects for events
  void showEventEffect(String eventType) {
    Color effectColor;
    String effectText;
    
    switch (eventType) {
      case 'immigration':
        effectColor = Colors.green;
        effectText = '+People';
        break;
      case 'emigration':
        effectColor = Colors.red;
        effectText = '-People';
        break;
      case 'milestone':
        effectColor = Colors.gold;
        effectText = 'Milestone!';
        break;
      default:
        effectColor = Colors.blue;
        effectText = 'Event';
    }
    
    final effectComponent = TextComponent(
      text: effectText,
      position: Vector2(size.x / 2, size.y / 3),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: effectColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    add(effectComponent);
    
    // Remove the effect after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      effectComponent.removeFromParent();
    });
  }
}