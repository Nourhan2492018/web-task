import 'package:flutter/material.dart';

// A simplified model to represent our items
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

// Simple in-memory implementation for demonstration
class MockItemsPage extends StatefulWidget {
  const MockItemsPage({super.key});

  @override
  State<MockItemsPage> createState() => _MockItemsPageState();
}

class _MockItemsPageState extends State<MockItemsPage> {
  // Mock items data
  final List<SimpleItem> _items = [
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
  List<SimpleItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    // Simulate loading
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _filteredItems = List.from(_items);
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshItems,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add a new item to get started',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(SimpleItem item) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showItemDetails(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with status badge
            Stack(
              children: [
                Image.network(
                  item.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item.status),
                      borderRadius: BorderRadius.circular(12),
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

            // Content section
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
                              fontWeight: FontWeight.bold,
                              color: _getCategoryColor(item.category),
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

                    // Date and users
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

    return Stack(
      children: [
        for (int i = 0; i < visibleUsers.length; i++)
          Positioned(
            right: i * 15.0, // Positioned from the right with overlap
            child: _buildUserAvatar(visibleUsers[i]),
          ),
        if (overflowCount > 0)
          Positioned(
            right: visibleUsers.length * 15.0,
            child: Container(
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

    // Don't use negative margins as they cause assertion errors
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Container(
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
      ),
    );
  }

  // Helper function to get color based on status
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

  // Helper function to get color based on category
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

  // Helper function to generate color based on user name
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

  void _refreshItems() {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _filteredItems = List.from(_items);
          _isLoading = false;
        });
      }
    });
  }

  void _showFilterDialog() {
    final categories = _items.map((item) => item.category).toSet().toList();
    final statuses = _items.map((item) => item.status).toSet().toList();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Items'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter By Category:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: true,
                      onSelected: (_) {
                        Navigator.pop(context);
                        setState(() {
                          _filteredItems = List.from(_items);
                        });
                      },
                    ),
                    ...categories.map(
                      (category) => FilterChip(
                        label: Text(category),
                        selected: false,
                        onSelected: (_) {
                          Navigator.pop(context);
                          setState(() {
                            _filteredItems =
                                _items
                                    .where((item) => item.category == category)
                                    .toList();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Filter By Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: true,
                      onSelected: (_) {
                        Navigator.pop(context);
                        setState(() {
                          _filteredItems = List.from(_items);
                        });
                      },
                    ),
                    ...statuses.map(
                      (status) => FilterChip(
                        label: Text(status),
                        selected: false,
                        onSelected: (_) {
                          Navigator.pop(context);
                          setState(() {
                            _filteredItems =
                                _items
                                    .where((item) => item.status == status)
                                    .toList();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showItemDetails(SimpleItem item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(item.title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              height: 200,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 40,
                              ),
                            ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Category', item.category),
                  _buildDetailRow('Status', item.status),
                  _buildDetailRow('Date Range', item.dateRange),
                  _buildDetailRow(
                    'Progress',
                    '${item.completedTasks}/${item.totalTasks} tasks',
                  ),
                  _buildDetailRow('Description', item.description),
                  const SizedBox(height: 8),
                  const Text(
                    'Assigned Users:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children:
                        item.assignedUsers.map((user) {
                          return Chip(
                            avatar: CircleAvatar(
                              backgroundColor: _getUserColor(user),
                              child: Text(
                                user[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            label: Text(user),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showEditItemDialog(item);
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(item);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Item'),
            content: const Text(
              'This feature would connect to Firebase in a real implementation.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showEditItemDialog(SimpleItem item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Item'),
            content: const Text(
              'This feature would connect to Firebase in a real implementation.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation(SimpleItem item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Item?'),
            content: Text(
              'Are you sure you want to delete "${item.title}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Mock deletion
                  setState(() {
                    _items.removeWhere((i) => i.id == item.id);
                    _filteredItems.removeWhere((i) => i.id == item.id);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.title} deleted successfully'),
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

// Main app
class SimpleItemsApp extends StatelessWidget {
  const SimpleItemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const MockItemsPage(),
    );
  }
}

void main() {
  runApp(const SimpleItemsApp());
}
