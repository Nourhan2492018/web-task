import 'package:flutter/material.dart';
import 'pages/items_page_figma.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DarkItemsApp());
}

class DarkItemsApp extends StatelessWidget {
  const DarkItemsApp({super.key});

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
      ),
      debugShowCheckedModeBanner: false,
      home: const ItemsPage(),
    );
  }
}
