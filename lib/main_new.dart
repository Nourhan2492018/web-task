import 'package:flutter/material.dart';
import './pages/items_page_figma.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        // fontFamily: 'Inter', // Uncomment after adding the font files
        cardTheme: const CardTheme(
          surfaceTintColor: Colors.white,
          elevation: 2,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const ItemsPage(),
    );
  }
}
