// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Siirtolaiset';

  @override
  String get territories => 'Alueet';

  @override
  String totalPopulation(String population) {
    return 'Yhteensä: $population';
  }

  @override
  String get locked => 'LUKITTU';

  @override
  String nextUnlock(String territory, String threshold) {
    return 'Seuraava avaus: $territory $threshold ihmisellä';
  }

  @override
  String get allTerritoriesUnlocked => 'Kaikki alueet avattu!';

  @override
  String get settings => 'Asetukset';

  @override
  String get language => 'Kieli';

  @override
  String get gameSpeed => 'Pelin nopeus';

  @override
  String get normalSpeed => 'Normaali';

  @override
  String get fastSpeed => 'Nopea';

  @override
  String get veryFastSpeed => 'Hyvin nopea';

  @override
  String get slowSpeed => 'Hidas';

  @override
  String get territoryUrbanCenterName => 'Kaupunkikeskus';

  @override
  String get territoryUrbanCenterDescription =>
      'Vilkas kaupunki työmahdollisuuksineen ja kulttuurisena monimuotoisuutena';

  @override
  String get territoryBorderTownName => 'Rajakaupunki';

  @override
  String get territoryBorderTownDescription =>
      'Strateginen paikka turvapaikkaa ja uusia alkuja hakeville';

  @override
  String get territoryCoastalPortName => 'Rannikkosatama';

  @override
  String get territoryCoastalPortDescription =>
      'Merellinen keskus kalastus- ja kauppamahdollisuuksineen';

  @override
  String get territoryCaveNetworkName => 'Luolaverkosto';

  @override
  String get territoryCaveNetworkDescription =>
      'Maanalaiset luolat, jotka tarjoavat suojaa ja turvaa';

  @override
  String get territoryUndergroundCityName => 'Maanalainen kaupunki';

  @override
  String get territoryUndergroundCityDescription =>
      'Piilotettu kaupunki maan pinnan alla edistyneillä tiloilla';

  @override
  String get territoryMountainSettlementName => 'Vuoristoasutus';

  @override
  String get territoryMountainSettlementDescription =>
      'Korkealla sijaitseva yhteisö upeilla näkymillä ja puhtaalla ilmalla';

  @override
  String get territoryDesertOutpostName => 'Aavikon tukikohta';

  @override
  String get territoryDesertOutpostDescription =>
      'Aurinkoenergialla toimiva asutus ankarassa aavikkoympäristössä';

  @override
  String get territoryArcticBaseName => 'Arktinen tukikohta';

  @override
  String get territoryArcticBaseDescription =>
      'Tutkimus- ja asuintilat jäätyneessä erämaassa';

  @override
  String get territoryOrbitalPlatformName => 'Kiertorata-alusta';

  @override
  String get territoryOrbitalPlatformDescription =>
      'Avaruudessa sijaitseva maata kiertävä asumusalue';

  @override
  String get territorySpaceStationAlphaName => 'Avaruusasema Alpha';

  @override
  String get territorySpaceStationAlphaDescription =>
      'Edistynyt planeettojen välinen keskus syvän avaruuden tutkimiseen';
}
