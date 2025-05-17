import 'package:flutter/material.dart';
import 'pages/items_page_figma.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ItemsApp());
}

class ItemsApp extends StatelessWidget {
  const ItemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Dashboard',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        colorScheme: ColorScheme.dark().copyWith(
          primary: const Color(0xFF3D5AFE),
        ),
        fontFamily: 'Inter', // Using Inter font from Figma design
        cardTheme: CardTheme(
          surfaceTintColor: const Color(0xFF2D2D2D),
          elevation: 2,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const ItemsPage(),
    );
  }
}
