import 'package:flutter/material.dart';
import '../models/item_model_fixed.dart';

/// A utility class that provides mock data for the app
class MockDataProvider {
  /// Generate a list of mock items for demonstration
  static List<ItemModel> getMockItems() {
    return List.generate(
      12,
      (index) => ItemModel(
        id: 'item-$index',
        title: 'Project Item ${index + 1}',
        description:
            'This is a mock item description for demonstration purposes.',
        imageUrl: 'https://picsum.photos/400/300?random=$index',
        createdAt: DateTime.now().subtract(Duration(days: index)),
        category: _getRandomCategory(index),
        status: _getRandomStatus(index),
        dateRange: 'May ${index + 1} - May ${index + 5}, 2025',
        assignedUsers: _getRandomUsers(index),
        totalTasks: 5 + index % 4,
        completedTasks: index % 4,
      ),
    );
  }

  static String _getRandomCategory(int index) {
    final categories = [
      'Design',
      'Development',
      'Marketing',
      'Research',
      'Testing',
    ];
    return categories[index % categories.length];
  }

  static String _getRandomStatus(int index) {
    final statuses = ['Active', 'Completed', 'On Hold', 'Pending Approval'];
    return statuses[index % statuses.length];
  }

  static List<String> _getRandomUsers(int index) {
    final baseUsers = [
      'User 1',
      'User 2',
      'User 3',
      'User 4',
      'User 5',
      'User 6',
      'User 7',
      'User 8',
    ];
    final count = 1 + (index % 8); // 1 to 8 users
    return baseUsers.take(count).toList();
  }
}
