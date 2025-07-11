import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/number_formatter.dart';

class StatisticsPanel extends StatelessWidget {
  const StatisticsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final gameState = gameProvider.gameState;
        
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Statistics',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                _buildStatRow(
                  context,
                  '⏰',
                  'Play Time',
                  NumberFormatter.formatTime(gameState.playTime),
                ),
                const SizedBox(height: 8),
                
                _buildStatRow(
                  context,
                  '🌾',
                  'Farms',
                  '${gameState.farms} (+${NumberFormatter.format(gameState.farms * 2.0)}/sec)',
                ),
                const SizedBox(height: 8),
                
                _buildStatRow(
                  context,
                  '🏠',
                  'Houses',
                  '${gameState.houses} (+${NumberFormatter.format(gameState.houses * 1.5)}/sec)',
                ),
                const SizedBox(height: 8),
                
                _buildStatRow(
                  context,
                  '🏫',
                  'Schools',
                  '${gameState.schools} (+${NumberFormatter.format(gameState.schools * 5.0)} happiness)',
                ),
                const SizedBox(height: 8),
                
                _buildStatRow(
                  context,
                  '🏥',
                  'Hospitals',
                  '${gameState.hospitals} (-${NumberFormatter.formatPercentage(gameState.hospitals * 10)} consumption)',
                ),
                const SizedBox(height: 8),
                
                _buildStatRow(
                  context,
                  '🏛️',
                  'Ports',
                  '${gameState.ports} (+${NumberFormatter.formatPercentage(gameState.ports * 20)} immigration)',
                ),
                const SizedBox(height: 8),
                
                _buildStatRow(
                  context,
                  '🔧',
                  'Workshops',
                  '${gameState.workshops} (+${NumberFormatter.formatPercentage(gameState.workshops * 50)} gathering)',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStatRow(BuildContext context, String icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}