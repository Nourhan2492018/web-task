import 'package:flutter/material.dart';
import '../models/item_model_fixed.dart';

// A simplified version of the items page that follows the Figma design
class SimpleItemsPage extends StatefulWidget {
  const SimpleItemsPage({super.key});

  @override
  State<SimpleItemsPage> createState() => _SimpleItemsPageState();
}

class _SimpleItemsPageState extends State<SimpleItemsPage> {
  List<ItemModel> _items = [];
  bool _isLoading = true;

  // Filter variables
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Active', 'Completed', 'On Hold'];

  // Search query
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMockData(); // Directly load mock data for now
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      appBar: AppBar(
        title: const Text('Items Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [_buildSearchBar(), Expanded(child: _buildContent())],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
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
          _buildFilterDropdown(),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          items:
              _filterOptions.map((String filter) {
                return DropdownMenuItem<String>(
                  value: filter,
                  child: Text(filter),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedFilter = newValue;
              });
            }
          },
          style: const TextStyle(color: Colors.black, fontSize: 14),
          icon: const Icon(Icons.filter_list),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No items match your search criteria'
                  : 'No items found for the selected filter',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
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
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    // Use a ListView instead of GridView to avoid layout issues
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildItemCard(_filteredItems[index]),
        );
      },
    );
  }

  Widget _buildItemCard(ItemModel item) {
    // Calculate progress percentage
    final progressPercentage =
        item.totalTasks > 0
            ? (item.completedTasks / item.totalTasks * 100).round()
            : 0;

    // Determine status color
    Color statusColor;
    switch (item.status) {
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
                    item.title,
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
                    item.status,
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
              item.description,
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
                  item.category,
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
                  item.dateRange,
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
                  '${item.completedTasks}/${item.totalTasks} tasks',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value:
                  item.totalTasks > 0
                      ? item.completedTasks / item.totalTasks
                      : 0,
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
                    item.assignedUsers.join(', '),
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
