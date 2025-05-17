// A simple item model that works with the WebFirebaseService
class ItemWeb {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String category;
  final String status;
  final String dateRange;
  final List<String> assignedUsers;
  final int totalTasks;
  final int completedTasks;

  ItemWeb({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.category,
    required this.status,
    required this.dateRange,
    required this.assignedUsers,
    required this.totalTasks,
    required this.completedTasks,
  });

  // Factory constructor to create an ItemWeb from a Firestore map
  factory ItemWeb.fromMap(Map<String, dynamic> map) {
    return ItemWeb(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: _parseDateTime(map['createdAt']),
      category: map['category'] ?? '',
      status: map['status'] ?? 'Pending',
      dateRange: map['dateRange'] ?? '',
      assignedUsers: _parseStringList(map['assignedUsers']),
      totalTasks: _parseInt(map['totalTasks']),
      completedTasks: _parseInt(map['completedTasks']),
    );
  }

  // Convert this item to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
      'status': status,
      'dateRange': dateRange,
      'assignedUsers': assignedUsers,
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
    };
  }

  // Helper method to parse DateTime
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }
    if (value is DateTime) {
      return value;
    }
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  // Helper method to parse int
  static int _parseInt(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is int) {
      return value;
    }
    try {
      return int.parse(value.toString());
    } catch (e) {
      return 0;
    }
  }

  // Helper method to parse string list
  static List<String> _parseStringList(dynamic value) {
    if (value == null) {
      return [];
    }
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return [];
  }
}
