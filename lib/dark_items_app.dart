import 'package:flutter/material.dart';
import 'models/item_model_fixed.dart';
import 'services/mock_data_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DarkModeItemsApp());
}

class DarkModeItemsApp extends StatelessWidget {
  const DarkModeItemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Dashboard',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        fontFamily: 'Inter', // Using Inter font from Figma design
        // Fallback to system fonts if Inter isn't available
        fontFamilyFallback: ['Roboto', 'Segoe UI', 'Arial', 'sans-serif'],
        cardTheme: const CardTheme(color: Color(0xFF171717), elevation: 2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF171717),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const DarkModeItemsPage(),
    );
  }
}

class DarkModeItemsPage extends StatefulWidget {
  const DarkModeItemsPage({super.key});

  @override
  State<DarkModeItemsPage> createState() => _DarkModeItemsPageState();
}

class _DarkModeItemsPageState extends State<DarkModeItemsPage> {
  List<ItemModel> _items = [];
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    // Load mock data
    _items = MockDataProvider.getMockItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items Dashboard'),
        actions: [
          // Toggle view button
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip:
                _isGridView ? 'Switch to List View' : 'Switch to Grid View',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isGridView ? _buildGridView() : _buildListView(),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return FigmaItemCard(item: _items[index]);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FigmaItemCard(item: _items[index]),
        );
      },
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
          ),
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
                    image: NetworkImage(
                      item.imageUrl.isNotEmpty
                          ? item.imageUrl
                          : "https://placehold.co/400x300/171717/FFFFFF/png?text=No+Image",
                    ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
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
    final displayCount =
        users.length > maxDisplayed ? maxDisplayed : users.length;
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
              border: Border.all(color: const Color(0xFF262626), width: 0.6),
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
