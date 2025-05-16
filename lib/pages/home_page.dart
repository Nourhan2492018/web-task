import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/responsive_layout.dart';
import '../services/firebase_service.dart';
import '../models/item_model.dart';
import '../theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    debugPrint('HomePage initState called'); // Debug print
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('HomePage build method called'); // Debug print
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getItems(),
              builder: (context, snapshot) {
                debugPrint(
                  'StreamBuilder update - hasError: ${snapshot.hasError}, '
                  'connectionState: ${snapshot.connectionState}, '
                  'hasData: ${snapshot.hasData}',
                ); // Debug print

                if (snapshot.hasError) {
                  debugPrint(
                    'StreamBuilder error: ${snapshot.error}',
                  ); // Debug print
                  if (snapshot.error.toString().contains('permission-denied')) {
                    return _buildErrorState(
                      context,
                      'Firebase permission denied. Please check your security rules.',
                    );
                  } else if (snapshot.error.toString().contains('network')) {
                    return _buildErrorState(
                      context,
                      'Network error. Please check your internet connection.',
                    );
                  }
                  return _buildErrorState(
                    context,
                    'Error loading data: ${snapshot.error}',
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState();
                }

                final items = snapshot.data?.docs ?? [];
                debugPrint(
                  'Number of items received: ${items.length}',
                ); // Debug print

                if (items.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ResponsiveLayout(
                  mobile: _buildItemsList(items, true),
                  desktop: _buildItemsList(items, false),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          debugPrint('Add button pressed'); // Debug print
          _addSampleItem(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add a New Item'),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    debugPrint('Building AppBar'); // Debug print
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Row(
        children: [
          const FlutterLogo(size: 32),
          const SizedBox(width: 24),
          _buildNavItem('Items', true),
          _buildNavItem('Pricing', false),
          _buildNavItem('Info', false),
          _buildNavItem('Tasks', false),
          _buildNavItem('Analytics', false),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        IconButton(
          icon: const Stack(
            children: [
              Icon(Icons.notifications_outlined),
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  backgroundColor: AppTheme.primaryOrange,
                  radius: 4,
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          radius: 16,
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildNavItem(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: isSelected ? AppTheme.primaryOrange : Colors.white,
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, ItemModel item) {
    return Card(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.imageUrl.isNotEmpty)
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Approval',
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.dateRange,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Stack(
                              children: [
                                for (
                                  var i = 0;
                                  i < item.assignedUsers.length;
                                  i++
                                )
                                  Positioned(
                                    left: i * 20.0,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        item.assignedUsers[i],
                                      ),
                                      radius: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.cardBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 16,
                                  color: AppTheme.textGrey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.completedTasks}/${item.totalTasks}',
                                  style: TextStyle(
                                    color: AppTheme.textGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(List<QueryDocumentSnapshot> items, bool isMobile) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isMobile ? 1.5 : 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        try {
          final doc = items[index];
          final item = ItemModel.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          );
          return _buildItemCard(context, item);
        } catch (e) {
          return Card(child: Center(child: Text('Error loading item: $e')));
        }
      },
    );
  }

  Future<void> _addSampleItem(BuildContext context) async {
    try {
      debugPrint('Adding sample item...'); // Debug print
      await _firebaseService.addItem({
        'title': 'Luxury Beach Resort Stay',
        'description':
            'Experience luxury at its finest with our beachfront resort accommodation.',
        'imageUrl':
            'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
        'createdAt': Timestamp.now(),
        'category': 'Accommodation',
        'status': 'Pending Approval',
        'dateRange': '5 Nights Jan 16 - Jan 20, 2024',
        'assignedUsers': [
          'https://i.pravatar.cc/150?img=1',
          'https://i.pravatar.cc/150?img=2',
          'https://i.pravatar.cc/150?img=3',
        ],
        'totalTasks': 8,
        'completedTasks': 2,
      });
      debugPrint('Sample item added successfully'); // Debug print
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sample item added successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Error adding sample item: $e'); // Debug print
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _addSampleItem(context),
            child: const Text('Try Adding Sample Data'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              debugPrint('Retrying data load...'); // Debug print
              setState(() {}); // Trigger rebuild to retry
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading items...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No items found'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _addSampleItem(context),
            child: const Text('Add Sample Item'),
          ),
        ],
      ),
    );
  }
}
