import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  // Firebase Web configuration
  static const FirebaseOptions webOptions = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    // Add other configuration values as needed for web
  );

  // Initialize Firebase with platform-specific options
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(options: webOptions);
  }
}
