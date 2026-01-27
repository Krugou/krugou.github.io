import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fi')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'The Immigrants'**
  String get appTitle;

  /// Label for territories section
  ///
  /// In en, this message translates to:
  /// **'Territories'**
  String get territories;

  /// Total population display
  ///
  /// In en, this message translates to:
  /// **'Total: {population}'**
  String totalPopulation(String population);

  /// Label for locked territories
  ///
  /// In en, this message translates to:
  /// **'LOCKED'**
  String get locked;

  /// Next unlock information
  ///
  /// In en, this message translates to:
  /// **'Next unlock: {territory} at {threshold} people'**
  String nextUnlock(String territory, String threshold);

  /// Message when all territories are unlocked
  ///
  /// In en, this message translates to:
  /// **'All territories unlocked!'**
  String get allTerritoriesUnlocked;

  /// Settings menu title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Game speed setting label
  ///
  /// In en, this message translates to:
  /// **'Game Speed'**
  String get gameSpeed;

  /// Normal game speed option
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalSpeed;

  /// Fast game speed option
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fastSpeed;

  /// Very fast game speed option
  ///
  /// In en, this message translates to:
  /// **'Very Fast'**
  String get veryFastSpeed;

  /// Slow game speed option
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slowSpeed;

  /// Name for village territory
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get territoryVillageName;

  /// Description for village territory
  ///
  /// In en, this message translates to:
  /// **'A small rural community with traditional values and close-knit families'**
  String get territoryVillageDescription;

  /// Name for urban center territory
  ///
  /// In en, this message translates to:
  /// **'Urban Center'**
  String get territoryUrbanCenterName;

  /// Description for urban center territory
  ///
  /// In en, this message translates to:
  /// **'A bustling city with job opportunities and cultural diversity'**
  String get territoryUrbanCenterDescription;

  /// Name for border town territory
  ///
  /// In en, this message translates to:
  /// **'Border Town'**
  String get territoryBorderTownName;

  /// Description for border town territory
  ///
  /// In en, this message translates to:
  /// **'A strategic location for those seeking refuge and new beginnings'**
  String get territoryBorderTownDescription;

  /// Name for coastal port territory
  ///
  /// In en, this message translates to:
  /// **'Coastal Port'**
  String get territoryCoastalPortName;

  /// Description for coastal port territory
  ///
  /// In en, this message translates to:
  /// **'A maritime hub with fishing and trade opportunities'**
  String get territoryCoastalPortDescription;

  /// Name for cave network territory
  ///
  /// In en, this message translates to:
  /// **'Cave Network'**
  String get territoryCaveNetworkName;

  /// Description for cave network territory
  ///
  /// In en, this message translates to:
  /// **'Underground caves providing shelter and protection'**
  String get territoryCaveNetworkDescription;

  /// Name for underground city territory
  ///
  /// In en, this message translates to:
  /// **'Underground City'**
  String get territoryUndergroundCityName;

  /// Description for underground city territory
  ///
  /// In en, this message translates to:
  /// **'A hidden city beneath the surface with advanced facilities'**
  String get territoryUndergroundCityDescription;

  /// Name for mountain settlement territory
  ///
  /// In en, this message translates to:
  /// **'Mountain Settlement'**
  String get territoryMountainSettlementName;

  /// Description for mountain settlement territory
  ///
  /// In en, this message translates to:
  /// **'High-altitude community with stunning views and clean air'**
  String get territoryMountainSettlementDescription;

  /// Name for desert outpost territory
  ///
  /// In en, this message translates to:
  /// **'Desert Outpost'**
  String get territoryDesertOutpostName;

  /// Description for desert outpost territory
  ///
  /// In en, this message translates to:
  /// **'Solar-powered settlement in the harsh desert environment'**
  String get territoryDesertOutpostDescription;

  /// Name for arctic base territory
  ///
  /// In en, this message translates to:
  /// **'Arctic Base'**
  String get territoryArcticBaseName;

  /// Description for arctic base territory
  ///
  /// In en, this message translates to:
  /// **'Research and residential facilities in the frozen wilderness'**
  String get territoryArcticBaseDescription;

  /// Name for orbital platform territory
  ///
  /// In en, this message translates to:
  /// **'Orbital Platform'**
  String get territoryOrbitalPlatformName;

  /// Description for orbital platform territory
  ///
  /// In en, this message translates to:
  /// **'Space-based habitat orbiting Earth'**
  String get territoryOrbitalPlatformDescription;

  /// Name for space station alpha territory
  ///
  /// In en, this message translates to:
  /// **'Space Station Alpha'**
  String get territorySpaceStationAlphaName;

  /// Description for space station alpha territory
  ///
  /// In en, this message translates to:
  /// **'Advanced interplanetary hub for deep space exploration'**
  String get territorySpaceStationAlphaDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fi':
      return AppLocalizationsFi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
