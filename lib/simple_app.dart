import 'package:flutter/material.dart';

void main() {
  runApp(const MySimpleApp());
}

class MySimpleApp extends StatelessWidget {
  const MySimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Items App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SimpleItemsPage(),
    );
  }
}

class SimpleItemsPage extends StatelessWidget {
  const SimpleItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildItemCard(
            title: 'Project Alpha',
            description:
                'A strategic initiative to improve customer engagement',
            status: 'Active',
            progress: 0.33,
          ),
          const SizedBox(height: 16),
          _buildItemCard(
            title: 'Market Research',
            description:
                'Comprehensive analysis of market trends and competitors',
            status: 'Completed',
            progress: 1.0,
          ),
          const SizedBox(height: 16),
          _buildItemCard(
            title: 'Product Redesign',
            description: 'Redesigning the core product interface for better UX',
            status: 'On Hold',
            progress: 0.38,
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required String description,
    required String status,
    required double progress,
  }) {
    // Determine status color
    Color statusColor;
    switch (status) {
      case 'Active':
        statusColor = Colors.green;
        break;
      case 'Completed':
        statusColor = Colors.blue;
        break;
      case 'On Hold':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    // Calculate progress percentage
    final progressPercentage = (progress * 100).round();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress: $progressPercentage%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
