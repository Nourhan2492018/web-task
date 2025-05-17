import 'dart:async';
import 'package:flutter/material.dart';

// Simple item model class that doesn't depend on any external packages
class SimpleItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String status;
  final String dateRange;
  final List<String> assignedUsers;
  final int totalTasks;
  final int completedTasks;

  SimpleItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.status,
    required this.dateRange,
    required this.assignedUsers,
    required this.totalTasks,
    required this.completedTasks,
  });
}

class MockHomePage extends StatefulWidget {
  const MockHomePage({super.key});

  @override
  State<MockHomePage> createState() => _MockHomePageState();
}

class _MockHomePageState extends State<MockHomePage> {
  // Define a theme color to use throughout the app
  final Color themeColor = Colors.blue;

  // Mock items
  final List<SimpleItem> items = [
    SimpleItem(
      id: '1',
      title: 'Project Alpha',
      description: 'A strategic initiative to improve customer engagement',
      imageUrl: 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0',
      category: 'Strategic',
      status: 'Active',
      dateRange: 'May 1 - Jul 30, 2023',
      assignedUsers: ['Alice', 'Bob', 'Charlie'],
      totalTasks: 24,
      completedTasks: 8,
    ),
    SimpleItem(
      id: '2',
      title: 'Website Redesign',
      description: 'Modernize our web presence with a fresh look and feel',
      imageUrl: 'https://images.unsplash.com/photo-1467232004584-a241de8bcf5d',
      category: 'Development',
      status: 'In Progress',
      dateRange: 'Jun 1 - Aug 15, 2023',
      assignedUsers: ['Dave', 'Eve', 'Frank'],
      totalTasks: 18,
      completedTasks: 6,
    ),
    SimpleItem(
      id: '3',
      title: 'Mobile App Upgrade',
      description: 'Adding new features and improving performance',
      imageUrl: 'https://images.unsplash.com/photo-1551650975-87deedd944c3',
      category: 'Development',
      status: 'On Hold',
      dateRange: 'Jul 1 - Sep 30, 2023',
      assignedUsers: ['Grace', 'Hank'],
      totalTasks: 32,
      completedTasks: 12,
    ),
    SimpleItem(
      id: '4',
      title: 'Marketing Campaign',
      description: 'Q3 digital marketing initiative across all channels',
      imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f',
      category: 'Marketing',
      status: 'Completed',
      dateRange: 'Apr 15 - Jun 15, 2023',
      assignedUsers: ['Irene', 'Jack', 'Kelly', 'Liam'],
      totalTasks: 45,
      completedTasks: 45,
    ),
  ];

  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    debugPrint('MockHomePage initState called'); // Debug print

    // Simulate loading
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MockHomePage build method called'); // Debug print
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _isLoading ? _buildLoadingState() : _buildItemsGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        tooltip: 'Add Item',
        backgroundColor: themeColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Flutter Web Dashboard'),
      backgroundColor: themeColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });

            Timer(const Duration(seconds: 1), () {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          },
          tooltip: 'Refresh',
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
          tooltip: 'Search',
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 16),
        const CircleAvatar(
          backgroundImage: NetworkImage(
            'https://randomuser.me/api/portraits/men/32.jpg',
          ),
          radius: 16,
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: themeColor.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Items Dashboard',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list),
                label: const Text('Filter'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: themeColor,
                  side: BorderSide(color: themeColor),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sort),
                label: const Text('Sort'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: themeColor,
                  side: BorderSide(color: themeColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: themeColor),
          const SizedBox(height: 16),
          const Text('Loading items...'),
        ],
      ),
    );
  }

  Widget _buildItemsGrid() {
    return items.isEmpty
        ? _buildEmptyState()
        : GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildItemCard(item);
          },
        );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a new item to get started',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _showAddItemDialog();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(SimpleItem item) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // View item details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with image and overlay
            Stack(
              children: [
                Image.network(
                  item.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item.status),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      item.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and category
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(
                              item.category,
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              fontSize: 10,
                              color: _getCategoryColor(item.category),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${item.completedTasks}/${item.totalTasks}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.task_alt, size: 14),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Description
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Date and assigned users
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.dateRange,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        _buildAssignedUsers(item.assignedUsers),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedUsers(List<String> users) {
    const maxVisible = 3;
    final visibleUsers = users.take(maxVisible).toList();
    final overflowCount = users.length - maxVisible;

    return Row(
      children: [
        ...visibleUsers.map((user) => _buildUserAvatar(user)).toList(),
        if (overflowCount > 0)
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+$overflowCount',
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserAvatar(String user) {
    // Convert user name to initials
    final initials = user
        .split(' ')
        .map((part) => part.isNotEmpty ? part[0].toUpperCase() : '')
        .take(2)
        .join('');

    return Container(
      margin: const EdgeInsets.only(right: -6),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: _getUserColor(user),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'on hold':
        return Colors.orange;
      case 'completed':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get category color
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'strategic':
        return Colors.indigo;
      case 'development':
        return Colors.teal;
      case 'marketing':
        return Colors.deepOrange;
      default:
        return Colors.blueGrey;
    }
  }

  // Helper method to generate color based on user name
  Color _getUserColor(String userName) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    final index = userName.hashCode % colors.length;
    return colors[index];
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Item'),
            content: const Text('This feature is not implemented in the demo.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
