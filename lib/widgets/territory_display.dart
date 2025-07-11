import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../utils/number_formatter.dart';

class TerritoryDisplay extends StatelessWidget {
  const TerritoryDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final territories = gameProvider.gameState.territories;
        final totalPopulation = gameProvider.gameState.totalPopulation;
        
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Territories',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Chip(
                      label: Text(
                        'Total: ${NumberFormatter.format(totalPopulation)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.indigo,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Territory list
                ...territories.map((territory) => _buildTerritoryItem(context, territory)),
                
                // Show next unlock threshold
                _buildNextUnlockInfo(context, totalPopulation),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildTerritoryItem(BuildContext context, Territory territory) {
    final isUnlocked = territory.isUnlocked;
    final populationPercentage = territory.population / territory.capacity;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.green.shade50 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUnlocked ? Colors.green : Colors.grey,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getTerritoryIcon(territory.type),
                color: isUnlocked ? Colors.green : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      territory.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Colors.black : Colors.grey,
                      ),
                    ),
                    Text(
                      territory.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isUnlocked ? Colors.black54 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (isUnlocked) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${NumberFormatter.format(territory.population)} / ${NumberFormatter.format(territory.capacity)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: populationPercentage,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      populationPercentage > 0.8 ? Colors.orange : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'LOCKED',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildNextUnlockInfo(BuildContext context, double totalPopulation) {
    String nextUnlockInfo = '';
    
    if (totalPopulation < 25) {
      nextUnlockInfo = 'Next unlock: Urban Center at 25 people';
    } else if (totalPopulation < 50) {
      nextUnlockInfo = 'Next unlock: Border Town at 50 people';
    } else if (totalPopulation < 75) {
      nextUnlockInfo = 'Next unlock: Coastal Port at 75 people';
    } else {
      nextUnlockInfo = 'All territories unlocked!';
    }
    
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Colors.blue.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              nextUnlockInfo,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
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
    }
  }
}