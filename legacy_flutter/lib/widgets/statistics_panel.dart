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
        final totalPopulation = gameState.totalPopulation;
        final totalEvents = gameState.eventHistory.length;
        final unlockedTerritories =
            gameState.territories.where((t) => t.isUnlocked).length;

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
                  '👥',
                  'Total Population',
                  NumberFormatter.format(totalPopulation),
                ),
                const SizedBox(height: 8),

                _buildStatRow(
                  context,
                  '🌍',
                  'Total Immigrants',
                  NumberFormatter.format(gameState.totalImmigrants.toDouble()),
                ),
                const SizedBox(height: 8),

                _buildStatRow(
                  context,
                  '🏞️',
                  'Territories Unlocked',
                  '$unlockedTerritories / ${gameState.territories.length}',
                ),
                const SizedBox(height: 8),

                _buildStatRow(
                  context,
                  '📋',
                  'Events Occurred',
                  NumberFormatter.format(totalEvents.toDouble()),
                ),
                const SizedBox(height: 8),

                // Territory breakdown
                const Divider(),
                Text(
                  'Territory Population',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                ...gameState.territories.where((t) => t.isUnlocked).map(
                      (territory) => _buildTerritoryStatRow(
                        context,
                        territory.name,
                        territory.population,
                        territory.capacity,
                      ),
                    ),

                if (gameState.territories
                    .where((t) => t.isUnlocked)
                    .isEmpty) ...[
                  const Text(
                    'No territories unlocked yet',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(
      BuildContext context, String icon, String label, String value) {
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

  Widget _buildTerritoryStatRow(
      BuildContext context, String name, double population, double capacity) {
    final percentage = (population / capacity * 100).toInt();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            '${NumberFormatter.format(population)} / ${NumberFormatter.format(capacity)} ($percentage%)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: percentage > 80 ? Colors.orange : Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
