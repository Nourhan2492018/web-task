import 'package:flutter/material.dart';

void main() {
  runApp(const BasicItemsApp());
}

class BasicItemsApp extends StatelessWidget {
  const BasicItemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Items App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const BasicItemsPage(),
    );
  }
}

class BasicItemsPage extends StatelessWidget {
  const BasicItemsPage({super.key});

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
            category: 'Strategic',
            status: 'Active',
            dateRange: 'May 1 - Jul 30, 2023',
            progress: 0.33,
            tasks: '8/24',
            users: 'Alice, Bob, Charlie',
          ),
          const SizedBox(height: 16),
          _buildItemCard(
            title: 'Market Research',
            description:
                'Comprehensive analysis of market trends and competitors',
            category: 'Research',
            status: 'Completed',
            dateRange: 'Apr 15 - May 15, 2023',
            progress: 1.0,
            tasks: '18/18',
            users: 'David, Emma',
          ),
          const SizedBox(height: 16),
          _buildItemCard(
            title: 'Product Redesign',
            description: 'Redesigning the core product interface for better UX',
            category: 'Design',
            status: 'On Hold',
            dateRange: 'Jun 1 - Aug 15, 2023',
            progress: 0.375,
            tasks: '12/32',
            users: 'Frank, Grace, Henry, Ivy',
          ),
          const SizedBox(height: 16),
          _buildItemCard(
            title: 'Backend Infrastructure',
            description: 'Scaling our backend services to support new features',
            category: 'Development',
            status: 'Active',
            dateRange: 'May 15 - Jul 1, 2023',
            progress: 0.48,
            tasks: '14/29',
            users: 'Jack, Kelly',
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required String description,
    required String category,
    required String status,
    required String dateRange,
    required double progress,
    required String tasks,
    required String users,
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
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  category,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  dateRange,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
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
                Text(
                  tasks,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    users,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
