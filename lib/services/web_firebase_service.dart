import 'dart:async';
import 'dart:convert';
import 'dart:js_util' as js_util;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:js/js.dart';

@JS('Promise')
class JSPromise<T> {
  external factory JSPromise(
    void Function(void Function(T) resolve, void Function(dynamic) reject)
    executor,
  );
}

// The bridge class to interact with Firebase via JavaScript
class WebFirebaseService {
  // Private constructor for singleton
  WebFirebaseService._();

  // Singleton instance
  static final WebFirebaseService instance = WebFirebaseService._();

  // Call the JavaScript function to get all items
  Future<List<Map<String, dynamic>>> getItems() async {
    try {
      print('Getting items via JavaScript interop');
      final jsPromise = js_util.callMethod<JSPromise>(
        html.window,
        'getFirestoreItems',
        [],
      );

      final dynamic jsItems = await js_util.promiseToFuture(jsPromise);

      if (jsItems == null) {
        return [];
      }

      // Convert JavaScript array to Dart List
      final List<dynamic> itemsList = js_util.dartify(jsItems) as List<dynamic>;
      return itemsList.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting items via JavaScript: $e');
      // Return empty list on error
      return [];
    }
  }

  // Call the JavaScript function to get an item by ID
  Future<Map<String, dynamic>?> getItemById(String id) async {
    try {
      print('Getting item by ID: $id via JavaScript interop');
      final jsPromise = js_util.callMethod<JSPromise>(
        html.window,
        'getFirestoreItemById',
        [id],
      );

      final dynamic jsItem = await js_util.promiseToFuture(jsPromise);

      if (jsItem == null) {
        return null;
      }

      return js_util.dartify(jsItem) as Map<String, dynamic>;
    } catch (e) {
      print('Error getting item by ID via JavaScript: $e');
      return null;
    }
  }

  // Call the JavaScript function to add a new item
  Future<String?> addItem(Map<String, dynamic> item) async {
    try {
      print('Adding item via JavaScript interop');
      final jsItem = js_util.jsify(item);

      final jsPromise = js_util.callMethod<JSPromise>(
        html.window,
        'addFirestoreItem',
        [jsItem],
      );

      final dynamic jsItemId = await js_util.promiseToFuture(jsPromise);

      if (jsItemId == null) {
        return null;
      }

      return jsItemId.toString();
    } catch (e) {
      print('Error adding item via JavaScript: $e');
      return null;
    }
  }

  // Call the JavaScript function to update an item
  Future<bool> updateItem(String id, Map<String, dynamic> data) async {
    try {
      print('Updating item with ID: $id via JavaScript interop');
      final jsData = js_util.jsify(data);

      final jsPromise = js_util.callMethod<JSPromise>(
        html.window,
        'updateFirestoreItem',
        [id, jsData],
      );

      final dynamic jsResult = await js_util.promiseToFuture(jsPromise);

      return jsResult == true;
    } catch (e) {
      print('Error updating item via JavaScript: $e');
      return false;
    }
  }

  // Call the JavaScript function to delete an item
  Future<bool> deleteItem(String id) async {
    try {
      print('Deleting item with ID: $id via JavaScript interop');

      final jsPromise = js_util.callMethod<JSPromise>(
        html.window,
        'deleteFirestoreItem',
        [id],
      );

      final dynamic jsResult = await js_util.promiseToFuture(jsPromise);

      return jsResult == true;
    } catch (e) {
      print('Error deleting item via JavaScript: $e');
      return false;
    }
  }
}
