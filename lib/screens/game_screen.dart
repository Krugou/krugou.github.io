import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../game/immigrants_game.dart';
import '../widgets/territory_display.dart';
import '../widgets/event_log.dart';
import '../widgets/action_buttons.dart';
import '../widgets/statistics_panel.dart';
import '../widgets/settings_widget.dart';
import '../screens/auth/login_screen.dart';
import '../services/preferences_service.dart';

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
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        backgroundColor: Colors.indigo,
        actions: [
          // Authentication button
          Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              return IconButton(
                icon: Icon(
                  gameProvider.isAuthenticated ? Icons.account_circle : Icons.login,
                ),
                onPressed: () {
                  if (gameProvider.isAuthenticated) {
                    _showUserMenu(context, gameProvider);
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _showResetDialog(context);
            },
          ),
        ],
      ),
      body: Consumer2<GameProvider, PreferencesService>(
        builder: (context, gameProvider, preferencesService, child) {
          // Update game display
          _game.updatePopulation(gameProvider.gameState.totalPopulation);
          
          // Sync game speed with preferences
          gameProvider.syncWithPreferences(preferencesService.gameSpeed);
          
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
                      // User status indicator
                      if (gameProvider.isAuthenticated)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.cloud_done, color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Signed in as ${gameProvider.currentUser?.displayName ?? 'User'}',
                                  style: TextStyle(color: Colors.green.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      if (gameProvider.isAuthenticated) const SizedBox(height: 16),
                      
                      // Settings Widget
                      const SettingsWidget(),
                      const SizedBox(height: 16),
                      
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
  
  void _showUserMenu(BuildContext context, GameProvider gameProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(gameProvider.currentUser?.displayName ?? 'User'),
              subtitle: Text(gameProvider.currentUser?.email ?? ''),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('Leaderboard'),
              onTap: () {
                Navigator.of(context).pop();
                _showLeaderboard(context, gameProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.of(context).pop();
                gameProvider.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showLeaderboard(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leaderboard'),
        content: FutureBuilder<List<Map<String, dynamic>>>(
          future: gameProvider.getLeaderboard(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No leaderboard data available.');
            }
            
            final leaderboard = snapshot.data!;
            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final entry = leaderboard[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(entry['displayName']),
                    subtitle: Text('Population: ${entry['totalPopulation']}'),
                    trailing: Text('${entry['totalImmigrants']} immigrants'),
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
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