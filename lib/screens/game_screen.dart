import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../providers/game_provider.dart';
import '../game/immigrants_game.dart';
import '../widgets/territory_display.dart';
import '../widgets/event_log.dart';
import '../widgets/action_buttons.dart';
import '../widgets/statistics_panel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ImmigrantsGame _game;
  
  @override
  void initState() {
    super.initState();
    _game = ImmigrantsGame();
    
    // Set up game event callback
    _game.onGameEvent = (eventType) {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      if (eventType == 'manual_immigration') {
        gameProvider.manualImmigration();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Immigrants'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _showResetDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          // Update game display
          _game.updatePopulation(gameProvider.gameState.totalPopulation);
          
          // Show recent event in game
          final recentEvents = gameProvider.getRecentEvents(limit: 1);
          if (recentEvents.isNotEmpty) {
            _game.updateEvent(recentEvents.first.description);
            _game.showEventEffect(recentEvents.first.type.name);
          }
          
          return Row(
            children: [
              // Flame Game View (left side)
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: GameWidget(game: _game),
                  ),
                ),
              ),
              
              // Game UI (right side)
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Territory Display
                      const TerritoryDisplay(),
                      const SizedBox(height: 16),
                      
                      // Action Buttons
                      const ActionButtons(),
                      const SizedBox(height: 16),
                      
                      // Event Log
                      const EventLog(),
                      const SizedBox(height: 16),
                      
                      // Statistics Panel
                      const StatisticsPanel(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Game'),
          content: const Text('Are you sure you want to reset your progress? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<GameProvider>(context, listen: false).resetGame();
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}