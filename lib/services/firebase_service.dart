import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseService() {
    print('FirebaseService initialized'); // Debug print
  }

  // Add a new item to the collection
  Future<void> addItem(Map<String, dynamic> item) async {
    try {
      print('Attempting to add item to Firestore...'); // Debug print
      await _firestore.collection('items').add(item);
      print('Item added successfully to Firestore'); // Debug print
    } catch (e) {
      print('Error adding item to Firestore: $e'); // Debug print
      rethrow;
    }
  }

  // Get all items from the collection
  Stream<QuerySnapshot> getItems() {
    print('Getting items stream from Firestore'); // Debug print
    return _firestore.collection('items').snapshots().handleError((error) {
      print('Error in Firestore stream: $error'); // Debug print
      throw error;
    });
  }dart pub global activate flutterfire_cli

  // Get a single item by ID
  Future<DocumentSnapshot> getItemById(String id) async {
    try {
      print('Getting item by ID: $id'); // Debug print
      final doc = await _firestore.collection('items').doc(id).get();
      print('Item retrieved successfully'); // Debug print
      return doc;
    } catch (e) {
      print('Error getting item by ID: $e'); // Debug print
      rethrow;
    }
  }

  // Update an item
  Future<void> updateItem(String id, Map<String, dynamic> data) async {
    try {
      print('Updating item with ID: $id'); // Debug print
      await _firestore.collection('items').doc(id).update(data);
      print('Item updated successfully'); // Debug print
    } catch (e) {
      print('Error updating item: $e'); // Debug print
      rethrow;
    }
  }

  // Delete an item
  Future<void> deleteItem(String id) async {
    try {
      print('Deleting item with ID: $id'); // Debug print
      await _firestore.collection('items').doc(id).delete();
      print('Item deleted successfully'); // Debug print
    } catch (e) {
      print('Error deleting item: $e'); // Debug print
      rethrow;
    }
  }
} 