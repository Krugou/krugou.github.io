import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void setupFirebaseAuthMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Set up mock method handlers for the required channels
  const MethodChannel firebaseCoreChannel = MethodChannel(
    'plugins.flutter.io/firebase_core',
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseCoreChannel, (MethodCall methodCall) async {
    if (methodCall.method == 'Firebase#initializeCore') {
      return [
        {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }
    if (methodCall.method == 'Firebase#initializeApp') {
      return {
        'name': methodCall.arguments['appName'],
        'options': methodCall.arguments['options'],
        'pluginConstants': {},
      };
    }
    return null;
  });

  // Mock for firebase auth
  const MethodChannel firebaseAuthChannel = MethodChannel(
    'plugins.flutter.io/firebase_auth',
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseAuthChannel, (MethodCall methodCall) async {
    return null;
  });

  // Mock for cloud firestore
  const MethodChannel cloudFirestoreChannel = MethodChannel(
    'plugins.flutter.io/cloud_firestore',
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(cloudFirestoreChannel, (MethodCall methodCall) async {
    return null;
  });
}
