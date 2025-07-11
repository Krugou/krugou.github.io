import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'providers/game_provider.dart';
import 'screens/game_screen.dart';
import 'models/event_system.dart';
import 'services/preferences_service.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyDQKYiEaLVmPBt9L-H2X-D7b_z2ENfu55I',
        authDomain: 'immigrants-game.firebaseapp.com',
        projectId: 'immigrants-game',
        storageBucket: 'immigrants-game.firebasestorage.app',
        messagingSenderId: '341726953439',
        appId: '1:341726953439:web:33f0add1b7b56353904e6a',
        measurementId: 'G-KD65KP4YST'),
  );

  // Initialize shared preferences for save/load functionality
  final prefs = await SharedPreferences.getInstance();

  // Initialize event system
  await EventSystem.initialize();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameProvider(prefs)),
        ChangeNotifierProvider(create: (context) => PreferencesService(prefs, DatabaseService())),
      ],
      child: Consumer<PreferencesService>(
        builder: (context, preferencesService, child) {
          return MaterialApp(
            title: 'The Immigrants',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              useMaterial3: true,
            ),
            // Localization support
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: PreferencesService.supportedLocales,
            locale: preferencesService.locale,
            home: const GameScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
