import 'package:flutter/material.dart';
import 'pages/items_page_figma.dart';

void main() {
  runApp(const ItemsApp());
}

class ItemsApp extends StatelessWidget {
  const ItemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Management',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        colorScheme: ColorScheme.dark().copyWith(
          primary: const Color(0xFF3D5AFE),
        ),
      ),
      home: const ItemsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
