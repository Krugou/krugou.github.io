import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../utils/number_formatter.dart';

class EventLog extends StatelessWidget {
  const EventLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final recentEvents = gameProvider.getRecentEvents(limit: 10);

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Events',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                if (recentEvents.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'No events yet. Wait for immigration events to occur!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Event list
                  ...recentEvents.map(
                      (event) => _buildEventItem(context, event, gameProvider)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventItem(
      BuildContext context, GameEvent event, GameProvider gameProvider) {
    final isPositive = event.populationChange > 0;
    final isNegative = event.populationChange < 0;
    final territory = event.targetTerritoryId != null
        ? gameProvider.getTerritory(event.targetTerritoryId!)
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getEventColor(event.type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getEventColor(event.type).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getEventIcon(event.type),
                color: _getEventColor(event.type),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getEventColor(event.type),
                  ),
                ),
              ),
              if (event.populationChange != 0) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colors.green
                        : (isNegative ? Colors.red : Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${NumberFormatter.format(event.populationChange)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            event.description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (territory != null) ...[
                Icon(
                  _getTerritoryIcon(territory.type),
                  size: 12,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  territory.name,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                _formatTimestamp(event.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.immigration:
        return Colors.green;
      case EventType.emigration:
        return Colors.red;
      case EventType.disaster:
        return Colors.orange;
      case EventType.opportunity:
        return Colors.blue;
      case EventType.milestone:
        return Colors.purple;
    }
  }

  IconData _getEventIcon(EventType type) {
    switch (type) {
      case EventType.immigration:
        return Icons.person_add;
      case EventType.emigration:
        return Icons.person_remove;
      case EventType.disaster:
        return Icons.warning;
      case EventType.opportunity:
        return Icons.star;
      case EventType.milestone:
        return Icons.flag;
    }
  }

  IconData _getTerritoryIcon(TerritoryType type) {
    switch (type) {
      case TerritoryType.rural:
        return Icons.agriculture;
      case TerritoryType.urban:
        return Icons.location_city;
      case TerritoryType.border:
        return Icons.border_all;
      case TerritoryType.coastal:
        return Icons.waves;
      case TerritoryType.caves:
        return Icons.landscape;
      case TerritoryType.underground:
        return Icons.subway;
      case TerritoryType.mountains:
        return Icons.terrain;
      case TerritoryType.desert:
        return Icons.wb_sunny;
      case TerritoryType.arctic:
        return Icons.ac_unit;
      case TerritoryType.orbital:
        return Icons.satellite;
      case TerritoryType.spaceStation:
        return Icons.rocket_launch;
      default:
        return Icons.location_on;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
