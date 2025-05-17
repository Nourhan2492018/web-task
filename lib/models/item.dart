import 'package:cloud_firestore/cloud_firestore.dart';

// This class defines the data model for our items that will be fetched from Firebase
class Item {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final int count;

  Item({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.count,
  });

  // Factory constructor to create an Item from a Firebase document
  factory Item.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Item(
      id: documentId,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      startDate:
          (data['startDate'] != null)
              ? (data['startDate'] as Timestamp).toDate()
              : DateTime.now(),
      endDate:
          (data['endDate'] != null)
              ? (data['endDate'] as Timestamp).toDate()
              : DateTime.now().add(const Duration(days: 7)),
      status: data['status'] ?? 'Unknown',
      count: data['count'] ?? 0,
    );
  }

  // Helper method to format dates for display
  String get dateRangeFormatted {
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
