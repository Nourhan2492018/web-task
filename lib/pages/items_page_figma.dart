import 'package:flutter/material.dart';
import '../models/item_model_fixed.dart';
import '../services/web_firebase_service_fixed.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final WebFirebaseService _firebaseService = WebFirebaseService();
  List<ItemModel> _items = [];
  bool _isLoading = true;
  String? _error;

  // Filter variables
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Active', 'Completed', 'On Hold', 'Pending Approval'];

  // Search query
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // View type (grid/list)
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Try loading from Firebase
      try {
        final items = await _firebaseService.getItems();
        
        // If items are empty, use mock data
        if (items.isEmpty) {
          _loadMockData();
        } else {
          setState(() {
            _items = items;
            _isLoading = false;
          });
        }
      } catch (e) {
        // If Firebase fails, load mock data
        _loadMockData();
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load items: $e';
        _isLoading = false;
      });

      // If we can't load items from Firebase, show a dialog with the option to use mock data
      if (mounted) {
        _showErrorDialog();
      }
    }
  }

  void _loadMockData() {
    // Create mock data for demonstration
    final items = List.generate(
      12,
      (index) => ItemModel(
        id: 'item-$index',
        title: 'Project Item ${index + 1}',
        description: 'This is a mock item description for demonstration purposes.',
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

    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  String _getRandomCategory(int index) {
    final categories = ['Design', 'Development', 'Marketing', 'Research', 'Testing'];
    return categories[index % categories.length];
  }

  String _getRandomStatus(int index) {
    final statuses = ['Active', 'Completed', 'On Hold', 'Pending Approval'];
    return statuses[index % statuses.length];
  }

  List<String> _getRandomUsers(int index) {
    final baseUsers = ['User 1', 'User 2', 'User 3', 'User 4', 'User 5', 'User 6', 'User 7', 'User 8'];
    final count = 1 + (index % 8); // 1 to 8 users
    return baseUsers.take(count).toList();
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error Loading Data'),
            content: Text(
              '$_error\n\nWould you like to load mock data instead?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _loadMockData();
                },
                child: const Text('Load Mock Data'),
              ),
            ],
          ),
    );
  }

  void _loadMockData() {
    setState(() {
      _items = [
        ItemModel(
          id: '1',
          title: 'Project Alpha',
          description: 'A strategic initiative to improve customer engagement',
          imageUrl: 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          category: 'Strategic',
          status: 'Active',
          dateRange: 'May 1 - Jul 30, 2023',
          assignedUsers: ['Alice', 'Bob', 'Charlie'],
          totalTasks: 24,
          completedTasks: 8,
        ),
        ItemModel(
          id: '2',
          title: 'Market Research',
          description:
              'Comprehensive analysis of market trends and competitors',
          imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          category: 'Research',
          status: 'Completed',
          dateRange: 'Apr 15 - May 15, 2023',
          assignedUsers: ['David', 'Emma'],
          totalTasks: 18,
          completedTasks: 18,
        ),
        ItemModel(
          id: '3',
          title: 'Product Redesign',
          description: 'Redesigning the core product interface for better UX',
          imageUrl:
              'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          category: 'Design',
          status: 'On Hold',
          dateRange: 'Jun 1 - Aug 15, 2023',
          assignedUsers: ['Frank', 'Grace', 'Henry', 'Ivy'],
          totalTasks: 32,
          completedTasks: 12,
        ),
        ItemModel(
          id: '4',
          title: 'Backend Infrastructure',
          description: 'Scaling our backend services to support new features',
          imageUrl:
              'https://images.unsplash.com/photo-1518432031352-d6fc5c10da5a',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          category: 'Development',
          status: 'Active',
          dateRange: 'May 15 - Jul 1, 2023',
          assignedUsers: ['Jack', 'Kelly'],
          totalTasks: 29,
          completedTasks: 14,
        ),
      ];
      _isLoading = false;
      _error = null;
    });
  }

  // Filter items based on status and search query
  List<ItemModel> get _filteredItems {
    return _items.where((item) {
      // Apply status filter
      if (_selectedFilter != 'All' && item.status != _selectedFilter) {
        return false;
      }

      // Apply search filter (if any)
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return item.title.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query) ||
            item.category.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark theme background
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(child: _buildContent()),
          _buildPaginationBar(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: const Color(0xFF2D2D2D), // Dark app bar background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Items',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // In a real app, this would navigate to an add item page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add item functionality coming soon!'),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D5AFE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF3B3B3B),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              // View toggle (grid/list)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3B3B3B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Grid view button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isGridView = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _isGridView
                                  ? const Color(0xFF3D5AFE)
                                  : const Color(0xFF3B3B3B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.grid_view,
                          color: _isGridView ? Colors.white : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    ),
                    // List view button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isGridView = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              !_isGridView
                                  ? const Color(0xFF3D5AFE)
                                  : const Color(0xFF3B3B3B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.view_list,
                          color: !_isGridView ? Colors.white : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildFilterDropdown(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B3B3B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          dropdownColor: const Color(0xFF3B3B3B),
          items:
              _filterOptions.map((String filter) {
                return DropdownMenuItem<String>(
                  value: filter,
                  child: Text(
                    filter,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedFilter = newValue;
              });
            }
          },
          style: const TextStyle(color: Colors.white, fontSize: 14),
          icon: Icon(Icons.filter_list, color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3D5AFE)),
        ),
      );
    }

    if (_error != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMockData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D5AFE),
              ),
              child: const Text('Load Mock Data'),
            ),
          ],
        ),
      );
    }

    if (_filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No items match your search criteria'
                  : 'No items found for the selected filter',
              style: TextStyle(fontSize: 18, color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                  _selectedFilter = 'All';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D5AFE),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
    //_isGridView ? _buildGridView() : _buildListView()
      child: _buildGridView(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9, // Adjusted for the Figma design
      ),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return FigmaItemCard(item: item);
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: _filteredItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return FigmaListItemCard(item: item);
      },
    );
  }

  Widget _buildPaginationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: const Color(0xFF2D2D2D),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${_filteredItems.isEmpty ? 0 : 1}-${_filteredItems.length} of ${_items.length} items',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          Row(
            children: [
              _buildPaginationButton(
                onPressed: () {},
                icon: Icons.navigate_before,
                label: 'Previous',
                enabled: false,
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D5AFE),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('1', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 8),
              _buildPaginationButton(
                onPressed: () {},
                icon: Icons.navigate_next,
                label: 'Next',
                enabled: false,
                iconRight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    bool enabled = true,
    bool iconRight = false,
  }) {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: enabled ? const Color(0xFF3D5AFE) : Colors.grey,
      ),
      child: Row(
        children: [
          if (!iconRight) Icon(icon, size: 18),
          if (!iconRight) const SizedBox(width: 4),
          Text(label),
          if (iconRight) const SizedBox(width: 4),
          if (iconRight) Icon(icon, size: 18),
        ],
      ),
    );
  }
}

// Reusable Components for Figma Design

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Active':
        statusColor = const Color(0xFF4CAF50); // Green
        break;
      case 'Completed':
        statusColor = const Color(0xFF2196F3); // Blue
        break;
      case 'On Hold':
        statusColor = const Color(0xFFFF9800); // Orange
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ProgressIndicatorWithLabel extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const ProgressIndicatorWithLabel({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercentage =
        totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress: $progressPercentage%',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              '$completedTasks/$totalTasks tasks',
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: totalTasks > 0 ? completedTasks / totalTasks : 0,
            backgroundColor: const Color(0xFF353535),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3D5AFE)),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class AssignedUsersRow extends StatelessWidget {
  final List<String> users;

  const AssignedUsersRow({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const SizedBox.shrink();
    }

    // Display up to 3 avatars
    const int maxDisplayed = 3;
    final displayCount =
        users.length > maxDisplayed ? maxDisplayed : users.length;
    final remainingCount = users.length - displayCount;

    return Row(
      children: [
        ...List.generate(
          displayCount,
          (index) => Padding(
            padding: EdgeInsets.only(
              right: index == displayCount - 1 ? 8.0 : 0,
            ),
            child: _buildUserAvatar(users[index], index),
          ),
        ),
        if (remainingCount > 0)
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF3D5AFE),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2D2D2D), width: 2),
            ),
            child: Center(
              child: Text(
                '+$remainingCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        const SizedBox(width: 8),
        Text(
          'Assigned to',
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(String initials, int index) {
    // Generate a unique but consistent color based on the user's name
    final colors = [
      const Color(0xFFF44336), // Red
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF2196F3), // Blue
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFF9800), // Orange
    ];

    final colorIndex = initials.hashCode % colors.length;

    return Container(
      margin: EdgeInsets.only(right: -10), // Overlap avatars
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: colors[colorIndex],
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2D2D2D), width: 2),
      ),
      child: Center(
        child: Text(
          initials.isNotEmpty ? initials[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class FigmaItemCard extends StatelessWidget {
  final ItemModel item;

  const FigmaItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Calculate unfinished tasks
    final unfinishedTasks = item.totalTasks - item.completedTasks;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Stack
          Stack(
            children: [
              // Image container
              Container(
                width: double.infinity,
                height: 182,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(item.imageUrl.isNotEmpty 
                        ? item.imageUrl 
                        : "https://placehold.co/400x300/171717/FFFFFF/png?text=No+Image"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                width: double.infinity,
                height: 182,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  gradient: LinearGradient(
                    begin: const Alignment(0.5, 0),
                    end: const Alignment(0.5, 0.95),
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              // Favorite Button (top right)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              // Category Badge (bottom right)
              if (item.category.isNotEmpty)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Card Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge
                Container(
                  height: 28,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: ShapeDecoration(
                    color: _getStatusColor(item.status).withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.5,
                        color: _getStatusColor(item.status),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.status,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        _getStatusIcon(item.status),
                        size: 16,
                        color: _getStatusColor(item.status),
                      ),
                    ],
                  ),
                ),
                
                // Title
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.44,
                    letterSpacing: -0.54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Date Range
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF999999),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.dateRange,
                      style: const TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.36,
                      ),
                    ),
                  ],
                ),
                
                // Divider
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  height: 0.5,
                  color: const Color(0xFF262626),
                ),
                
                // Bottom Row - Assigned Users and Tasks
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Assigned Users
                    _buildAssignedUsers(item.assignedUsers),
                    
                    // Unfinished Tasks Count
                    Text(
                      '$unfinishedTasks unfinished task${unfinishedTasks != 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF4CAF50); // Green
      case 'Completed':
        return const Color(0xFF2196F3); // Blue
      case 'On Hold':
        return const Color(0xFFFF9800); // Orange
      case 'Pending Approval':
        return const Color(0xFFC25F30); // Orange-red
      default:
        return const Color(0xFF999999); // Grey
    }
  }
  
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Active':
        return Icons.play_arrow;
      case 'Completed':
        return Icons.check_circle_outline;
      case 'On Hold':
        return Icons.pause_circle_outline;
      case 'Pending Approval':
        return Icons.access_time;
      default:
        return Icons.info_outline;
    }
  }
  
  Widget _buildAssignedUsers(List<String> users) {
    if (users.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Display up to 4 avatars
    const int maxDisplayed = 4;
    final displayCount = users.length > maxDisplayed ? maxDisplayed : users.length;
    final remainingCount = users.length - displayCount;
    
    return Row(
      children: [
        ...List.generate(
          displayCount,
          (index) => Container(
            margin: EdgeInsets.only(right: index < displayCount - 1 ? -8 : 0),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(_getUserAvatarUrl(users[index])),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: const Color(0xFF262626),
                width: 0.6,
              ),
            ),
          ),
        ),
        
        // Plus count if more users
        if (remainingCount > 0)
          Container(
            margin: const EdgeInsets.only(left: -8),
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF262626),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+$remainingCount',
                style: const TextStyle(
                  color: Color(0xFFFFC268),
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  String _getUserAvatarUrl(String user) {
    // Example function to generate an avatar URL
    // In a real app, you'd use the actual user avatar URLs
    // For now, we'll just use placeholder images
    return "https://placehold.co/24x24";
  }
}

class FigmaListItemCard extends StatelessWidget {
  final ItemModel item;

  const FigmaListItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return 
     Column(
      children: [
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            color: const Color(0xFF171717),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 243.20,
                height: 182,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.50, 0.00),
                    end: Alignment(0.50, 0.95),
                    colors: [Colors.black, Colors.black.withValues(alpha: 0)],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Container(
                width: 243.20,
                height: 182.53,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://placehold.co/243x183"),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: ShapeDecoration(
                      color: Colors.black.withValues(alpha: 153),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: 243.25,
                padding: const EdgeInsets.only(
                  top: 14,
                  left: 15,
                  right: 15,
                  bottom: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Container(
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: ShapeDecoration(
                              color: const Color(0x19C25F30),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  color: const Color(0xFFC25F30),
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 6,
                              children: [
                                Text(
                                  'Pending Approval',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.57,
                                    letterSpacing: -0.42,
                                  ),
                                ),
                                Container(
                                  width: 16,
                                  height: 16,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Stack(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 6,
                              children: [
                                SizedBox(
                                  width: 213.25,
                                  child: Text(
                                    'Item title',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.44,
                                      letterSpacing: -0.54,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 6,
                                  children: [
                                    Container(width: 16, height: 16, child: Stack()),
                                    Text(
                                      'Jan 16 - Jan 20, 2024',
                                      style: TextStyle(
                                        color: const Color(0xFF999999),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                        letterSpacing: -0.36,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.50,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: const Color(0xFF262626),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 271.08,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("https://placehold.co/24x24"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 0.60,
                                              color: const Color(0xFF262626),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("https://placehold.co/24x24"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 0.60,
                                              color: const Color(0xFF262626),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("https://placehold.co/24x24"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 0.60,
                                              color: const Color(0xFF262626),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF262626),
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 0.60,
                                              color: const Color(0xFF262626),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 10.80,
                                        height: 10.80,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF262626),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(60),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4.80,
                                          children: [
                                            Text(
                                              '+6',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: const Color(0xFFFFC268),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.29,
                                                letterSpacing: -0.42,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '4 unfinished tasks',
                            style: TextStyle(
                              color: const Color(0xFF999999),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                              letterSpacing: -0.36,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    // Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Image thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      item.imageUrl.isNotEmpty
                          ? Image.network(
                            item.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  width: 50,
                                  height: 50,
                                  color: const Color(0xFF3B3B3B),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[600],
                                  ),
                                ),
                          )
                          : Container(
                            width: 50,
                            height: 50,
                            color: const Color(0xFF3B3B3B),
                            child: Icon(
                              Icons.business,
                              color: Colors.grey[600],
                            ),
                          ),
                ),
                const SizedBox(width: 12),
                // Status badge
                Expanded(child: StatusBadge(status: item.status)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            InfoRow(icon: Icons.category_outlined, text: item.category),
            const SizedBox(height: 6),
            InfoRow(icon: Icons.calendar_today_outlined, text: item.dateRange),
            const SizedBox(height: 16),
            ProgressIndicatorWithLabel(
              totalTasks: item.totalTasks,
              completedTasks: item.completedTasks,
            ),
            const Spacer(),
            AssignedUsersRow(users: item.assignedUsers),
          ],
        ),
      ),
    );
  }
}

class FigmaListItemCard extends StatelessWidget {
  final ItemModel item;

  const FigmaListItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return 
     Column(
      children: [
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            color: const Color(0xFF171717),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 243.20,
                height: 182,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.50, 0.00),
                    end: Alignment(0.50, 0.95),
                    colors: [Colors.black, Colors.black.withValues(alpha: 0)],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Container(
                width: 243.20,
                height: 182.53,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://placehold.co/243x183"),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: ShapeDecoration(
                      color: Colors.black.withValues(alpha: 153),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: 243.25,
                padding: const EdgeInsets.only(
                  top: 14,
                  left: 15,
                  right: 15,
                  bottom: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Container(
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: ShapeDecoration(
                              color: const Color(0x19C25F30),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  color: const Color(0xFFC25F30),
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 6,
                              children: [
                                Text(
                                  'Pending Approval',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.57,
                                    letterSpacing: -0.42,
                                  ),
                                ),
                                Container(
                                  width: 16,
                                  height: 16,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Stack(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 6,
                              children: [
                                SizedBox(
                                  width: 213.25,
                                  child: Text(
                                    'Item title',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.44,
                                      letterSpacing: -0.54,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 6,
                                  children: [
                                    Container(width: 16, height: 16, child: Stack()),
                                    Text(
                                      'Jan 16 - Jan 20, 2024',
                                      style: TextStyle(
                                        color: const Color(0xFF999999),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                        letterSpacing: -0.36,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.50,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: const Color(0xFF262626),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 271.08,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("https://placehold.co/24x24"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 0.60,
                                              color: const Color(0xFF262626),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("https://placehold.co/24x24"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 0.60,
                                              color: const Color(0xFF262626),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("https://placehold.co/24x24"),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 0.60,
                                              color: const Color(0xFF262626),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF262626),
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 0.60,
                                              color: const Color(0xFF262626),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 10.80,
                                        height: 10.80,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF262626),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(60),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4.80,
                                          children: [
                                            Text(
                                              '+6',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: const Color(0xFFFFC268),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.29,
                                                letterSpacing: -0.42,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '4 unfinished tasks',
                            style: TextStyle(
                              color: const Color(0xFF999999),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                              letterSpacing: -0.36,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    // Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  item.imageUrl.isNotEmpty
                      ? Image.network(
                        item.imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: 120,
                              height: 120,
                              color: const Color(0xFF3B3B3B),
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[600],
                                size: 40,
                              ),
                            ),
                      )
                      : Container(
                        width: 120,
                        height: 120,
                        color: const Color(0xFF3B3B3B),
                        child: Icon(
                          Icons.business,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                      ),
            ),
            const SizedBox(width: 16),
            // Right side - Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusBadge(status: item.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InfoRow(
                          icon: Icons.category_outlined,
                          text: item.category,
                        ),
                      ),
                      Expanded(
                        child: InfoRow(
                          icon: Icons.calendar_today_outlined,
                          text: item.dateRange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ProgressIndicatorWithLabel(
                    totalTasks: item.totalTasks,
                    completedTasks: item.completedTasks,
                  ),
                  const SizedBox(height: 16),
                  AssignedUsersRow(users: item.assignedUsers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
