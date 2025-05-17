import 'package:flutter/material.dart';
import 'pages/simple_items_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SimpleApp());
}

class SimpleApp extends StatelessWidget {
  const SimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: const CardTheme(
          surfaceTintColor: Colors.white,
          elevation: 2,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SimpleItemsPage(),
    );
  }
}
