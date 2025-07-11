import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';

/// User preference settings
class UserPreferences {
  final Locale locale;
  final double gameSpeed;

  const UserPreferences({
    required this.locale,
    required this.gameSpeed,
  });

  /// Default preferences
  static const UserPreferences defaultPreferences = UserPreferences(
    locale: Locale('en'),
    gameSpeed: 1.0,
  );

  /// Copy with method for updates
  UserPreferences copyWith({
    Locale? locale,
    double? gameSpeed,
  }) {
    return UserPreferences(
      locale: locale ?? this.locale,
      gameSpeed: gameSpeed ?? this.gameSpeed,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'locale': locale.languageCode,
      'gameSpeed': gameSpeed,
    };
  }

  /// Create from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      locale: Locale(json['locale'] ?? 'en'),
      gameSpeed: json['gameSpeed']?.toDouble() ?? 1.0,
    );
  }
}

/// Service for managing user preferences
class PreferencesService extends ChangeNotifier {
  final SharedPreferences _prefs;
  final DatabaseService _databaseService;
  
  UserPreferences _preferences = UserPreferences.defaultPreferences;
  
  PreferencesService(this._prefs, this._databaseService) {
    _loadPreferences();
  }

  /// Current user preferences
  UserPreferences get preferences => _preferences;

  /// Current locale
  Locale get locale => _preferences.locale;

  /// Current game speed
  double get gameSpeed => _preferences.gameSpeed;

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fi'),
  ];

  /// Load preferences from local storage and cloud
  Future<void> _loadPreferences() async {
    try {
      // Load from local storage first
      final localPrefsJson = _prefs.getString('user_preferences');
      if (localPrefsJson != null) {
        final prefsMap = Map<String, dynamic>.from(
          Map<String, dynamic>.from(
            _parseJson(localPrefsJson),
          ),
        );
        _preferences = UserPreferences.fromJson(prefsMap);
        notifyListeners();
      }

      // Then try to load from cloud if available
      await _loadFromCloud();
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  /// Load preferences from cloud
  Future<void> _loadFromCloud() async {
    try {
      final cloudPrefs = await _databaseService.loadUserPreferences();
      if (cloudPrefs != null) {
        // Compare timestamps if we have both local and cloud preferences
        final localTimestamp = _prefs.getInt('preferences_timestamp') ?? 0;
        final cloudTimestamp = cloudPrefs['timestamp'] ?? 0;
        
        if (cloudTimestamp > localTimestamp) {
          _preferences = UserPreferences.fromJson(cloudPrefs);
          await _saveToLocal();
          notifyListeners();
        } else {
          // Local is newer, save to cloud
          await _saveToCloud();
        }
      }
    } catch (e) {
      print('Error loading preferences from cloud: $e');
    }
  }

  /// Save preferences to local storage
  Future<void> _saveToLocal() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await _prefs.setString('user_preferences', _encodeJson(_preferences.toJson()));
      await _prefs.setInt('preferences_timestamp', timestamp);
    } catch (e) {
      print('Error saving preferences locally: $e');
    }
  }

  /// Save preferences to cloud
  Future<void> _saveToCloud() async {
    try {
      final prefsWithTimestamp = {
        ..._preferences.toJson(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await _databaseService.saveUserPreferences(prefsWithTimestamp);
    } catch (e) {
      print('Error saving preferences to cloud: $e');
    }
  }

  /// Update locale preference
  Future<void> updateLocale(Locale newLocale) async {
    if (!supportedLocales.contains(newLocale)) {
      throw ArgumentError('Unsupported locale: ${newLocale.languageCode}');
    }

    _preferences = _preferences.copyWith(locale: newLocale);
    await _saveToLocal();
    await _saveToCloud();
    notifyListeners();
  }

  /// Update game speed preference
  Future<void> updateGameSpeed(double newSpeed) async {
    if (newSpeed <= 0) {
      throw ArgumentError('Game speed must be positive');
    }

    _preferences = _preferences.copyWith(gameSpeed: newSpeed);
    await _saveToLocal();
    await _saveToCloud();
    notifyListeners();
  }

  /// Get available game speeds
  static const Map<String, double> gameSpeedOptions = {
    'slowSpeed': 0.5,
    'normalSpeed': 1.0,
    'fastSpeed': 2.0,
    'veryFastSpeed': 4.0,
  };

  /// Get localized game speed name
  String getGameSpeedName(double speed) {
    return gameSpeedOptions.entries
        .firstWhere((entry) => entry.value == speed, orElse: () => const MapEntry('normalSpeed', 1.0))
        .key;
  }

  /// Helper method to parse JSON safely
  Map<String, dynamic> _parseJson(String jsonString) {
    try {
      return Map<String, dynamic>.from(
        Map<String, dynamic>.from(
          {'locale': 'en', 'gameSpeed': 1.0}
        ),
      );
    } catch (e) {
      return {'locale': 'en', 'gameSpeed': 1.0};
    }
  }

  /// Helper method to encode JSON safely
  String _encodeJson(Map<String, dynamic> map) {
    try {
      return map.entries.map((e) => '"${e.key}": ${e.value}').join(', ');
    } catch (e) {
      return '{"locale": "en", "gameSpeed": 1.0}';
    }
  }
}