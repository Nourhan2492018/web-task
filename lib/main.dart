import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with web config
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAl9Y5ltFXhMbiZ_6U1SA2LH1fRD6NoWrI",
      authDomain: "flutter-web-app-d9ab2.firebaseapp.com",
      projectId: "flutter-web-app-d9ab2",
      storageBucket: "flutter-web-app-d9ab2.firebasestorage.app",
      messagingSenderId: "526903582031",
      appId: "1:526903582031:web:2176b6f440cb2abc78793a",
      measurementId: "G-FLLRTFRP4S",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web UI',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}


