import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_web.dart';
import '../services/web_firebase_service_alt.dart';

class FirebaseItemsPage extends StatefulWidget {
  const FirebaseItemsPage({super.key});

  @override
  State<FirebaseItemsPage> createState() => _FirebaseItemsPageState();
}

class _FirebaseItemsPageState extends State<FirebaseItemsPage> {
  final WebFirebaseService _firebaseService = WebFirebaseService.instance;
  List<ItemWeb> _items = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Load items from Firebase (via JavaScript interop)
  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final itemsData = await _firebaseService.getItems();
      setState(() {
        _items = itemsData.map((data) => ItemWeb.fromMap(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading items: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Items'),
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

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text('Error', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(_errorMessage!),
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
            const Icon(Icons.inventory, color: Colors.grey, size: 60),
            const SizedBox(height: 16),
            Text(
              'No Items Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Add your first item to get started'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showAddItemDialog,
              child: const Text('Add Item'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
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

  Widget _buildItemCard(ItemWeb item) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () => _showItemDetails(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with status badge
            Stack(
              children: [
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 40),
                        ),
                      );
                    },
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
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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

                    // Category and tasks
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Row(
                          children: [
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

  // Show item details in a dialog
  void _showItemDetails(ItemWeb item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(item.title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _detailRow('Description', item.description),
                  _detailRow('Category', item.category),
                  _detailRow('Status', item.status),
                  _detailRow('Date Range', item.dateRange),
                  _detailRow('Created At', _formatDate(item.createdAt)),
                  _detailRow(
                    'Tasks',
                    '${item.completedTasks}/${item.totalTasks}',
                  ),
                  _detailRow('Assigned Users', item.assignedUsers.join(', ')),
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
                  _confirmDeleteItem(item);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  // Show edit item dialog
  void _showEditItemDialog(ItemWeb item) {
    final titleController = TextEditingController(text: item.title);
    final descController = TextEditingController(text: item.description);
    final imageUrlController = TextEditingController(text: item.imageUrl);
    final dateRangeController = TextEditingController(text: item.dateRange);

    String category = item.category;
    String status = item.status;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Item'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                  TextField(
                    controller: dateRangeController,
                    decoration: const InputDecoration(labelText: 'Date Range'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items:
                        ['Strategic', 'Development', 'Marketing', 'Research']
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        category = value;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items:
                        ['Active', 'In Progress', 'On Hold', 'Completed']
                            .map(
                              (stat) => DropdownMenuItem(
                                value: stat,
                                child: Text(stat),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        status = value;
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _updateItem(item.id, {
                    'title': titleController.text,
                    'description': descController.text,
                    'imageUrl': imageUrlController.text,
                    'dateRange': dateRangeController.text,
                    'category': category,
                    'status': status,
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  // Show add item dialog
  void _showAddItemDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final imageUrlController = TextEditingController();
    final dateRangeController = TextEditingController();
    String category = 'Development';
    String status = 'Active';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Item'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'https://example.com/image.jpg',
                    ),
                  ),
                  TextField(
                    controller: dateRangeController,
                    decoration: const InputDecoration(
                      labelText: 'Date Range',
                      hintText: 'Jan 1 - Mar 31, 2023',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items:
                        ['Strategic', 'Development', 'Marketing', 'Research']
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        category = value;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items:
                        ['Active', 'In Progress', 'On Hold', 'Completed']
                            .map(
                              (stat) => DropdownMenuItem(
                                value: stat,
                                child: Text(stat),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        status = value;
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _addItem({
                    'title': titleController.text,
                    'description': descController.text,
                    'imageUrl':
                        imageUrlController.text.isEmpty
                            ? 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0'
                            : imageUrlController.text,
                    'createdAt': DateTime.now().toIso8601String(),
                    'category': category,
                    'status': status,
                    'dateRange': dateRangeController.text,
                    'assignedUsers': ['User 1', 'User 2'],
                    'totalTasks': 5,
                    'completedTasks': 0,
                  });
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  // Confirm delete dialog
  void _confirmDeleteItem(ItemWeb item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text('Are you sure you want to delete "${item.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteItem(item.id);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  // Helper for detail rows in item details
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // Add a new item to Firebase
  Future<void> _addItem(Map<String, dynamic> item) async {
    try {
      final id = await _firebaseService.addItem(item);
      if (id != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully')),
        );
        _loadItems();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to add item')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Update an item in Firebase
  Future<void> _updateItem(String id, Map<String, dynamic> data) async {
    try {
      final success = await _firebaseService.updateItem(id, data);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item updated successfully')),
        );
        _loadItems();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to update item')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Delete an item from Firebase
  Future<void> _deleteItem(String id) async {
    try {
      final success = await _firebaseService.deleteItem(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted successfully')),
        );
        _loadItems();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to delete item')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Helper to format date
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
      case 'research':
        return Colors.amber[800]!;
      default:
        return Colors.blueGrey;
    }
  }
}
