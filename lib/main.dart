import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/game_provider.dart';
import 'screens/game_screen.dart';
import 'models/event_system.dart';

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
    return ChangeNotifierProvider(
      create: (context) => GameProvider(prefs),
      child: MaterialApp(
        title: 'The Immigrants',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const GameScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
