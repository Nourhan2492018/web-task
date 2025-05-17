import 'dart:async';
import 'dart:js_util' as js_util;
import 'dart:html' as html;

import '../models/item_model_fixed.dart';

/// A service that interacts with Firebase through JavaScript interop
class WebFirebaseService {
  WebFirebaseService() {
    print('WebFirebaseService initialized');
  }
  
  /// Get all items from Firestore
  Future<List<ItemModel>> getItems() async {
    try {
      final dynamic itemsPromise = js_util.callMethod(
        html.window, 
        'getFirestoreItems', 
        []
      );
      
      final dynamic itemsJson = await js_util.promiseToFuture(itemsPromise);
      List<dynamic> itemsList = itemsJson as List<dynamic>;
      
      return itemsList.map((item) {
        final Map<String, dynamic> itemMap = Map<String, dynamic>.from(item);
        return ItemModel.fromMap(itemMap['id'], itemMap);
      }).toList();
    } catch (e) {
      print('Error getting items from Firebase: $e');
      // Return empty list in case of error
      return [];
    }
  }

  /// Get a single item by ID
  Future<ItemModel?> getItemById(String id) async {
    try {
      final dynamic itemPromise = js_util.callMethod(
        html.window, 
        'getFirestoreItemById', 
        [id]
      );
      
      final dynamic itemJson = await js_util.promiseToFuture(itemPromise);
      if (itemJson == null) {
        return null;
      }
      
      final Map<String, dynamic> itemMap = Map<String, dynamic>.from(itemJson);
      return ItemModel.fromMap(itemMap['id'], itemMap);
    } catch (e) {
      print('Error getting item by ID from Firebase: $e');
      return null;
    }
  }

  /// Add a new item
  Future<String?> addItem(ItemModel item) async {
    try {
      final dynamic addPromise = js_util.callMethod(
        html.window, 
        'addFirestoreItem', 
        [item.toMap()]
      );
      
      final String itemId = await js_util.promiseToFuture(addPromise);
      return itemId;
    } catch (e) {
      print('Error adding item to Firebase: $e');
      return null;
    }
  }

  /// Update an existing item
  Future<bool> updateItem(String id, ItemModel item) async {
    try {
      final dynamic updatePromise = js_util.callMethod(
        html.window, 
        'updateFirestoreItem', 
        [id, item.toMap()]
      );
      
      final bool success = await js_util.promiseToFuture(updatePromise);
      return success;
    } catch (e) {
      print('Error updating item in Firebase: $e');
      return false;
    }
  }

  /// Delete an item
  Future<bool> deleteItem(String id) async {
    try {
      final dynamic deletePromise = js_util.callMethod(
        html.window, 
        'deleteFirestoreItem', 
        [id]
      );
      
      final bool success = await js_util.promiseToFuture(deletePromise);
      return success;
    } catch (e) {
      print('Error deleting item from Firebase: $e');
      return false;
    }
  }
}

  /// Get a single item by ID
  Future<ItemModel?> getItemById(String id) async {
    try {
      final dynamic itemPromise = js_util.callMethod(
        html.window, 
        'getFirestoreItemById', 
        [id]
      );
      
      final dynamic itemJson = await js_util.promiseToFuture(itemPromise);
      if (itemJson == null) {
        return null;
      }
      
      final Map<String, dynamic> itemMap = Map<String, dynamic>.from(itemJson);
      return ItemModel.fromMap(itemMap['id'], itemMap);
    } catch (e) {
      print('Error getting item by ID from Firebase: $e');
      return null;
    }
  }

  /// Add a new item
  Future<String?> addItem(ItemModel item) async {
    try {
      final dynamic addPromise = js_util.callMethod(
        html.window, 
        'addFirestoreItem', 
        [item.toMap()]
      );
      
      final String itemId = await js_util.promiseToFuture(addPromise);
      return itemId;
    } catch (e) {
      print('Error adding item to Firebase: $e');
      return null;
    }
  }

  /// Update an existing item
  Future<bool> updateItem(String id, ItemModel item) async {
    try {
      final dynamic updatePromise = js_util.callMethod(
        html.window, 
        'updateFirestoreItem', 
        [id, item.toMap()]
      );
      
      final bool success = await js_util.promiseToFuture(updatePromise);
      return success;
    } catch (e) {
      print('Error updating item in Firebase: $e');
      return false;
    }
  }

  /// Delete an item
  Future<bool> deleteItem(String id) async {
    try {
      final dynamic deletePromise = js_util.callMethod(
        html.window, 
        'deleteFirestoreItem', 
        [id]
      );
      
      final bool success = await js_util.promiseToFuture(deletePromise);
      return success;
    } catch (e) {
      print('Error deleting item from Firebase: $e');
      return false;
    }
  }
}
