import 'package:flutter/material.dart';
import '../models/item_model_fixed.dart';
import '../services/web_firebase_service_fixed.dart';

class FirebaseItemsPage extends StatefulWidget {
  const FirebaseItemsPage({super.key});

  @override
  State<FirebaseItemsPage> createState() => _FirebaseItemsPageState();
}

class _FirebaseItemsPageState extends State<FirebaseItemsPage> {
  final WebFirebaseService _firebaseService = WebFirebaseService();
  List<ItemModel> _items = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final items = await _firebaseService.getItems();

      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load items: $e';
        _isLoading = false;
      });
    }
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
            onPressed: _loadItems,
            tooltip: 'Refresh',
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

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text('Error', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadItems,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
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
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(ItemModel item) {
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

  void _showItemDetails(ItemModel item) {
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
            content: const Text('This feature is not implemented in the demo.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showEditItemDialog(ItemModel item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Item'),
            content: const Text('This feature is not implemented in the demo.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation(ItemModel item) {
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
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    setState(() => _isLoading = true);
                    final success = await _firebaseService.deleteItem(item.id);
                    if (success) {
                      setState(() {
                        _items.removeWhere((i) => i.id == item.id);
                        _isLoading = false;
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.title} deleted successfully'),
                          ),
                        );
                      }
                    } else {
                      setState(() => _isLoading = false);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to delete item'),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    setState(() => _isLoading = false);
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
