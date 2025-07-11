import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/population_display.dart';
import '../widgets/resource_display.dart';
import '../widgets/action_buttons.dart';
import '../widgets/upgrade_panel.dart';
import '../widgets/statistics_panel.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Population Display
                const PopulationDisplay(),
                const SizedBox(height: 16),
                
                // Resource Display
                const ResourceDisplay(),
                const SizedBox(height: 16),
                
                // Action Buttons
                const ActionButtons(),
                const SizedBox(height: 16),
                
                // Upgrade Panel
                const UpgradePanel(),
                const SizedBox(height: 16),
                
                // Statistics Panel
                const StatisticsPanel(),
              ],
            ),
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