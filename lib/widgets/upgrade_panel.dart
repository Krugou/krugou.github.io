import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/upgrade.dart';
import '../utils/number_formatter.dart';

class UpgradePanel extends StatelessWidget {
  const UpgradePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Community Upgrades',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                // Grid of upgrades
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: Upgrade.allUpgrades.length,
                  itemBuilder: (context, index) {
                    final upgrade = Upgrade.allUpgrades[index];
                    final currentCount = _getUpgradeCount(gameProvider, upgrade.type);
                    final cost = upgrade.getCost(currentCount);
                    final canAfford = gameProvider.canAffordUpgrade(upgrade.type);
                    
                    return Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: canAfford
                            ? () => gameProvider.buyUpgrade(upgrade.type)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                upgrade.icon,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                upgrade.name,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Count: $currentCount',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                upgrade.getBenefit(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.green,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: canAfford ? Colors.blue : Colors.grey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Cost: ${NumberFormatter.format(cost)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  int _getUpgradeCount(GameProvider gameProvider, UpgradeType type) {
    switch (type) {
      case UpgradeType.farm:
        return gameProvider.gameState.farms;
      case UpgradeType.house:
        return gameProvider.gameState.houses;
      case UpgradeType.school:
        return gameProvider.gameState.schools;
      case UpgradeType.hospital:
        return gameProvider.gameState.hospitals;
      case UpgradeType.port:
        return gameProvider.gameState.ports;
      case UpgradeType.workshop:
        return gameProvider.gameState.workshops;
    }
  }
}