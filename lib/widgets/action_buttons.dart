import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/number_formatter.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final canAffordImmigration = gameProvider.gameState.food >= 5.0;
        
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Actions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    // Gather Food Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => gameProvider.gatherFood(),
                        icon: const Text('🌾', style: TextStyle(fontSize: 20)),
                        label: const Text('Gather Food'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Manual Immigration Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: canAffordImmigration
                            ? () => gameProvider.manualImmigration()
                            : null,
                        icon: const Text('👥', style: TextStyle(fontSize: 20)),
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Welcome Immigrant'),
                            Text(
                              'Cost: ${NumberFormatter.format(5.0)} food',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canAffordImmigration
                              ? Colors.blue
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Workshop bonus display
                if (gameProvider.gameState.workshops > 0)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Workshop Bonus: +${NumberFormatter.formatPercentage(gameProvider.gameState.workshops * 50)}% food gathering',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}