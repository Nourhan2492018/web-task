import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataInitializer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Call this method once to initialize sample data
  Future<void> initializeSampleData() async {
    try {
      // Check if items collection already has data
      final snapshot = await _firestore.collection('items').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('Sample data already exists.');
        return;
      }
      
      // Create sample items
      final sampleItems = [
        {
          'title': 'Office Chair',
          'imageUrl': 'https://images.unsplash.com/photo-1596162954151-cdcb4c0f70a8?q=80&w=774&auto=format&fit=crop',
          'startDate': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 30))),
          'endDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 60))),
          'status': 'Active',
          'count': 24,
        },
        {
          'title': 'Standing Desk',
          'imageUrl': 'https://images.unsplash.com/photo-1517166963936-42a1e937a6a4?q=80&w=776&auto=format&fit=crop',
          'startDate': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 15))),
          'endDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 45))),
          'status': 'Pending',
          'count': 12,
        },
        {
          'title': 'Ergonomic Keyboard',
          'imageUrl': 'https://images.unsplash.com/photo-1541140532154-b024d705b90a?q=80&w=776&auto=format&fit=crop',
          'startDate': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
          'endDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 25))),
          'status': 'Active',
          'count': 36,
        },
        {
          'title': 'Monitor',
          'imageUrl': 'https://images.unsplash.com/photo-1550439062-609e1531270e?q=80&w=1470&auto=format&fit=crop',
          'startDate': Timestamp.fromDate(DateTime.now()),
          'endDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 90))),
          'status': 'Active',
          'count': 18,
        },
        {
          'title': 'Wireless Mouse',
          'imageUrl': 'https://images.unsplash.com/photo-1615292868312-7e48e86c06c2?q=80&w=774&auto=format&fit=crop',
          'startDate': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 60))),
          'endDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
          'status': 'Completed',
          'count': 42,
        },
        {
          'title': 'Laptop Stand',
          'imageUrl': 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?q=80&w=774&auto=format&fit=crop',
          'startDate': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 10))),
          'endDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 50))),
          'status': 'Pending',
          'count': 15,
        },
      ];
      
      // Add sample items to Firestore
      for (final item in sampleItems) {
        await _firestore.collection('items').add(item);
      }
      
      print('Sample data initialized successfully');
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }
}
