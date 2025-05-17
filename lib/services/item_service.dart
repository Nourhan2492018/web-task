import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

enum DataStatus { loading, success, error }

class ItemsResult {
  final List<Item> items;
  final DataStatus status;
  final String? errorMessage;

  ItemsResult({required this.items, required this.status, this.errorMessage});

  factory ItemsResult.loading() {
    return ItemsResult(items: [], status: DataStatus.loading);
  }

  factory ItemsResult.success(List<Item> items) {
    return ItemsResult(items: items, status: DataStatus.success);
  }

  factory ItemsResult.error(String message) {
    return ItemsResult(
      items: [],
      status: DataStatus.error,
      errorMessage: message,
    );
  }
}

class ItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a stream of items from Firestore
  Stream<ItemsResult> getItems() {
    return _firestore
        .collection('items')
        .snapshots()
        .map((snapshot) {
          try {
            final items =
                snapshot.docs
                    .map((doc) => Item.fromFirestore(doc.data(), doc.id))
                    .toList();
            return ItemsResult.success(items);
          } catch (e) {
            return ItemsResult.error('Failed to parse item data: $e');
          }
        })
        .handleError(
          (error) => ItemsResult.error('Failed to fetch items: $error'),
        );
  }

  // Get items as a Future (one-time fetch)
  Future<ItemsResult> getItemsOnce() async {
    try {
      final snapshot = await _firestore.collection('items').get();
      final items =
          snapshot.docs
              .map((doc) => Item.fromFirestore(doc.data(), doc.id))
              .toList();
      return ItemsResult.success(items);
    } catch (e) {
      return ItemsResult.error('Failed to fetch items: $e');
    }
  }

  // Get a single item by ID
  Future<Item?> getItemById(String id) async {
    try {
      final doc = await _firestore.collection('items').doc(id).get();
      if (doc.exists) {
        return Item.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting item: $e');
      return null;
    }
  }
}
