import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/preferences_service.dart';
import '../l10n/app_localizations.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<PreferencesService>(
      builder: (context, preferencesService, child) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.settings,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),

                // Language setting
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(localizations.language),
                  trailing: DropdownButton<Locale>(
                    value: preferencesService.locale,
                    onChanged: (Locale? newLocale) {
                      if (newLocale != null) {
                        preferencesService.updateLocale(newLocale);
                      }
                    },
                    items: PreferencesService.supportedLocales.map((locale) {
                      return DropdownMenuItem<Locale>(
                        value: locale,
                        child: Text(_getLanguageName(locale)),
                      );
                    }).toList(),
                  ),
                ),

                const Divider(),

                // Game speed setting
                ListTile(
                  leading: const Icon(Icons.speed),
                  title: Text(localizations.gameSpeed),
                  trailing: DropdownButton<double>(
                    value: preferencesService.gameSpeed,
                    onChanged: (double? newSpeed) {
                      if (newSpeed != null) {
                        preferencesService.updateGameSpeed(newSpeed);
                      }
                    },
                    items: PreferencesService.gameSpeedOptions.entries
                        .map((entry) {
                      return DropdownMenuItem<double>(
                        value: entry.value,
                        child: Text(_getGameSpeedName(context, entry.key)),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 8),

                // Game speed info
                Container(
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
                          'Current speed: ${preferencesService.gameSpeed}x',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fi':
        return 'Suomi';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  String _getGameSpeedName(BuildContext context, String speedKey) {
    final localizations = AppLocalizations.of(context)!;

    switch (speedKey) {
      case 'slowSpeed':
        return localizations.slowSpeed;
      case 'normalSpeed':
        return localizations.normalSpeed;
      case 'fastSpeed':
        return localizations.fastSpeed;
      case 'veryFastSpeed':
        return localizations.veryFastSpeed;
      default:
        return speedKey;
    }
  }
}
