import 'package:cloud_firestore/cloud_firestore.dart';

class DataInitializer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initializeSampleData() async {
    // Sample items data
    final List<Map<String, dynamic>> sampleItems = [
      {
        'title': 'Luxury Beach Resort Stay',
        'description': 'Experience luxury at its finest with our beachfront resort accommodation.',
        'imageUrl': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'category': 'Accommodation',
        'status': 'Pending Approval',
        'dateRange': '5 Nights Jan 16 - Jan 20, 2024',
        'assignedUsers': [
          'https://i.pravatar.cc/150?img=1',
          'https://i.pravatar.cc/150?img=2',
          'https://i.pravatar.cc/150?img=3'
        ],
        'totalTasks': 8,
        'completedTasks': 2,
      },
      {
        'title': 'Mountain View Cabin Retreat',
        'description': 'Cozy cabin with breathtaking mountain views and modern amenities.',
        'imageUrl': 'https://images.unsplash.com/photo-1587061949409-02df41d5e562?w=800',
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'category': 'Accommodation',
        'status': 'Pending Approval',
        'dateRange': '3 Nights Feb 1 - Feb 4, 2024',
        'assignedUsers': [
          'https://i.pravatar.cc/150?img=4',
          'https://i.pravatar.cc/150?img=5'
        ],
        'totalTasks': 6,
        'completedTasks': 4,
      },
      {
        'title': 'Urban Loft Experience',
        'description': 'Modern loft in the heart of downtown with city skyline views.',
        'imageUrl': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        'createdAt': Timestamp.now(),
        'category': 'Accommodation',
        'status': 'Pending Approval',
        'dateRange': '7 Nights Mar 10 - Mar 17, 2024',
        'assignedUsers': [
          'https://i.pravatar.cc/150?img=6',
          'https://i.pravatar.cc/150?img=7',
          'https://i.pravatar.cc/150?img=8'
        ],
        'totalTasks': 10,
        'completedTasks': 3,
      }
    ];

    // Check if collection is empty before adding sample data
    final QuerySnapshot existingItems = await _firestore.collection('items').get();
    
    if (existingItems.docs.isEmpty) {
      // Add each item to Firestore
      for (final item in sampleItems) {
        try {
          await _firestore.collection('items').add(item);
          print('Added item: ${item['title']}');
        } catch (e) {
          print('Error adding item ${item['title']}: $e');
        }
      }
      print('Sample data initialized successfully');
    } else {
      print('Collection already contains data, skipping initialization');
    }
  }

  Future<void> clearAllData() async {
    final QuerySnapshot items = await _firestore.collection('items').get();
    
    for (final doc in items.docs) {
      await doc.reference.delete();
    }
    print('All items cleared');
  }
} 