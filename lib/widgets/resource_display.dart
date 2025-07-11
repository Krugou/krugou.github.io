import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/number_formatter.dart';

class ResourceDisplay extends StatelessWidget {
  const ResourceDisplay({Key? key}) : super(key: key);

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
                  'Resources',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                // Food
                _buildResourceRow(
                  context,
                  '🍞',
                  'Food',
                  gameState.food,
                  Colors.orange,
                ),
                const SizedBox(height: 8),
                
                // Housing
                _buildResourceRow(
                  context,
                  '🏠',
                  'Housing',
                  gameState.housing,
                  Colors.brown,
                ),
                const SizedBox(height: 8),
                
                // Happiness
                _buildResourceRow(
                  context,
                  '😊',
                  'Happiness',
                  gameState.happiness,
                  Colors.green,
                  isPercentage: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildResourceRow(
    BuildContext context,
    String icon,
    String name,
    double value,
    Color color, {
    bool isPercentage = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          isPercentage 
            ? NumberFormatter.formatPercentage(value)
            : NumberFormatter.format(value),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}