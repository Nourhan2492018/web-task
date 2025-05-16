import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp createdAt;
  final String category;
  final String status;
  final String dateRange;
  final List<String> assignedUsers;
  final int totalTasks;
  final int completedTasks;

  ItemModel({
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

  factory ItemModel.fromMap(String id, Map<String, dynamic> map) {
    return ItemModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
      category: map['category'] ?? '',
      status: map['status'] ?? 'Pending Approval',
      dateRange: map['dateRange'] ?? '',
      assignedUsers: List<String>.from(map['assignedUsers'] ?? []),
      totalTasks: map['totalTasks'] ?? 0,
      completedTasks: map['completedTasks'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'category': category,
      'status': status,
      'dateRange': dateRange,
      'assignedUsers': assignedUsers,
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
    };
  }
} 