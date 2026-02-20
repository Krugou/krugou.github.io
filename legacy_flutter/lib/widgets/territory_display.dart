import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../models/territory_config.dart';
import '../utils/number_formatter.dart';
import '../l10n/app_localizations.dart';

class TerritoryDisplay extends StatelessWidget {
  const TerritoryDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                      localizations.territories,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Chip(
                      label: Text(
                        localizations.totalPopulation(
                            NumberFormatter.format(totalPopulation)),
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
                ...territories.map(
                    (territory) => _buildTerritoryItem(context, territory)),

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
    final localizations = AppLocalizations.of(context)!;
    final isUnlocked = territory.isUnlocked;
    final populationPercentage = territory.population / territory.capacity;

    // Get localized name and description
    final localizedName = _getLocalizedTerritoryName(context, territory.id);
    final localizedDescription =
        _getLocalizedTerritoryDescription(context, territory.id);

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
                      localizedName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Colors.black : Colors.grey,
                      ),
                    ),
                    Text(
                      localizedDescription,
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
              child: Text(
                localizations.locked,
                style: const TextStyle(
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
    final localizations = AppLocalizations.of(context)!;

    // Get the next territory to unlock using the new configuration system
    final nextConfig =
        TerritoryConfigManager.getNextUnlockConfig(totalPopulation);

    String nextUnlockInfo;
    if (nextConfig != null) {
      // Get localized territory name
      final territoryName = _getLocalizedTerritoryName(context, nextConfig.id);
      final threshold = NumberFormatter.format(nextConfig.threshold);

      nextUnlockInfo = localizations.nextUnlock(territoryName, threshold);
    } else {
      nextUnlockInfo = localizations.allTerritoriesUnlocked;
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

  /// Get localized territory name based on territory ID
  String _getLocalizedTerritoryName(BuildContext context, String territoryId) {
    final localizations = AppLocalizations.of(context)!;

    switch (territoryId) {
      case 'village':
        return localizations.territoryVillageName;
      case 'urban_center':
        return localizations.territoryUrbanCenterName;
      case 'border_town':
        return localizations.territoryBorderTownName;
      case 'coastal_port':
        return localizations.territoryCoastalPortName;
      case 'cave_network':
        return localizations.territoryCaveNetworkName;
      case 'underground_city':
        return localizations.territoryUndergroundCityName;
      case 'mountain_settlement':
        return localizations.territoryMountainSettlementName;
      case 'desert_outpost':
        return localizations.territoryDesertOutpostName;
      case 'arctic_base':
        return localizations.territoryArcticBaseName;
      case 'orbital_platform':
        return localizations.territoryOrbitalPlatformName;
      case 'space_station_alpha':
        return localizations.territorySpaceStationAlphaName;
      default:
        return territoryId;
    }
  }

  /// Get localized territory description based on territory ID
  String _getLocalizedTerritoryDescription(
      BuildContext context, String territoryId) {
    final localizations = AppLocalizations.of(context)!;

    switch (territoryId) {
      case 'village':
        return localizations.territoryVillageDescription;
      case 'urban_center':
        return localizations.territoryUrbanCenterDescription;
      case 'border_town':
        return localizations.territoryBorderTownDescription;
      case 'coastal_port':
        return localizations.territoryCoastalPortDescription;
      case 'cave_network':
        return localizations.territoryCaveNetworkDescription;
      case 'underground_city':
        return localizations.territoryUndergroundCityDescription;
      case 'mountain_settlement':
        return localizations.territoryMountainSettlementDescription;
      case 'desert_outpost':
        return localizations.territoryDesertOutpostDescription;
      case 'arctic_base':
        return localizations.territoryArcticBaseDescription;
      case 'orbital_platform':
        return localizations.territoryOrbitalPlatformDescription;
      case 'space_station_alpha':
        return localizations.territorySpaceStationAlphaDescription;
      default:
        return territoryId;
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
}
