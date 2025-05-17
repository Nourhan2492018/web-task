import 'dart:async';
import 'firebase_rest_service.dart';

class ItemRestService {
  final FirebaseRestService _restService = FirebaseRestService();
  final String collection = 'items';

  // A local cache of items to simulate a stream
  List<Map<String, dynamic>> _cachedItems = [];
  final _itemsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  ItemRestService() {
    // Initialize the stream with data
    _refreshItems();

    // Refresh items every 5 seconds to simulate real-time updates
    Timer.periodic(const Duration(seconds: 5), (_) => _refreshItems());
  }

  // Private method to refresh items
  Future<void> _refreshItems() async {
    try {
      _cachedItems = await _restService.getItems(collection);
      _itemsController.add(_cachedItems);
    } catch (e) {
      print('Error refreshing items: $e');
      _itemsController.addError(e);
    }
  }

  // Get a stream of all items (simulated)
  Stream<List<Map<String, dynamic>>> getItems() {
    return _itemsController.stream;
  }

  // Get a single item by ID
  Future<Map<String, dynamic>?> getItemById(String id) {
    return _restService.getItemById(collection, id);
  }

  // Add a new item
  Future<String> addItem(Map<String, dynamic> item) async {
    final id = await _restService.addItem(collection, item);
    _refreshItems(); // Update the cache and stream
    return id;
  }

  // Update an item
  Future<void> updateItem(String id, Map<String, dynamic> data) async {
    await _restService.updateItem(collection, id, data);
    _refreshItems(); // Update the cache and stream
  }

  // Delete an item
  Future<void> deleteItem(String id) async {
    await _restService.deleteItem(collection, id);
    _refreshItems(); // Update the cache and stream
  }

  // Clean up resources
  void dispose() {
    _itemsController.close();
  }
}
