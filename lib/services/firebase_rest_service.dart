import 'dart:convert';
import 'package:http/http.dart' as http;

// This class provides a simple HTTP-based alternative to Firebase SDK
// It uses Firebase REST API for Firestore
class FirebaseRestService {
  // Replace with your Firebase project ID
  final String projectId = 'flutter-web-app-d9ab2';
  final String baseUrl = 'https://firestore.googleapis.com/v1/projects/';

  FirebaseRestService() {
    print('FirebaseRestService initialized'); // Debug print
  }

  // Get collection URL
  String _getCollectionUrl(String collection) {
    return '$baseUrl$projectId/databases/(default)/documents/$collection';
  }

  // Get document URL
  String _getDocumentUrl(String collection, String docId) {
    return '${_getCollectionUrl(collection)}/$docId';
  }

  // Convert Firestore document to a Map
  Map<String, dynamic> _convertFirestoreDocument(
    Map<String, dynamic> document,
  ) {
    final Map<String, dynamic> result = {
      'id': document['name'].split('/').last,
    };

    final fields = document['fields'];
    if (fields != null) {
      fields.forEach((key, value) {
        // Handle different Firestore field types
        if (value.containsKey('stringValue')) {
          result[key] = value['stringValue'];
        } else if (value.containsKey('integerValue')) {
          result[key] = int.parse(value['integerValue']);
        } else if (value.containsKey('doubleValue')) {
          result[key] = value['doubleValue'];
        } else if (value.containsKey('booleanValue')) {
          result[key] = value['booleanValue'];
        } else if (value.containsKey('timestampValue')) {
          result[key] = DateTime.parse(value['timestampValue']);
        } else if (value.containsKey('arrayValue')) {
          result[key] = _convertArrayValue(value['arrayValue']);
        } else if (value.containsKey('mapValue')) {
          result[key] = _convertMapValue(value['mapValue']);
        }
      });
    }

    return result;
  }

  // Convert Firestore array value
  List _convertArrayValue(Map<String, dynamic> arrayValue) {
    List result = [];
    final values = arrayValue['values'];
    if (values != null) {
      for (var value in values) {
        if (value.containsKey('stringValue')) {
          result.add(value['stringValue']);
        } else if (value.containsKey('integerValue')) {
          result.add(int.parse(value['integerValue']));
        } else if (value.containsKey('doubleValue')) {
          result.add(value['doubleValue']);
        } else if (value.containsKey('booleanValue')) {
          result.add(value['booleanValue']);
        }
      }
    }
    return result;
  }

  // Convert Firestore map value
  Map<String, dynamic> _convertMapValue(Map<String, dynamic> mapValue) {
    final result = <String, dynamic>{};
    final fields = mapValue['fields'];
    if (fields != null) {
      fields.forEach((key, value) {
        if (value.containsKey('stringValue')) {
          result[key] = value['stringValue'];
        } else if (value.containsKey('integerValue')) {
          result[key] = int.parse(value['integerValue']);
        } else if (value.containsKey('doubleValue')) {
          result[key] = value['doubleValue'];
        } else if (value.containsKey('booleanValue')) {
          result[key] = value['booleanValue'];
        }
      });
    }
    return result;
  }

  // Convert a Map to Firestore format
  Map<String, dynamic> _convertToFirestoreDocument(Map<String, dynamic> data) {
    final Map<String, dynamic> fields = {};

    data.forEach((key, value) {
      if (value is String) {
        fields[key] = {'stringValue': value};
      } else if (value is int) {
        fields[key] = {'integerValue': value.toString()};
      } else if (value is double) {
        fields[key] = {'doubleValue': value};
      } else if (value is bool) {
        fields[key] = {'booleanValue': value};
      } else if (value is DateTime) {
        fields[key] = {'timestampValue': value.toIso8601String()};
      } else if (value is List) {
        fields[key] = {
          'arrayValue': {'values': _convertToFirestoreArray(value)},
        };
      } else if (value is Map) {
        fields[key] = {
          'mapValue': {'fields': _convertToFirestoreMap(value)},
        };
      }
    });

    return {'fields': fields};
  }

  // Convert a List to Firestore format
  List<Map<String, dynamic>> _convertToFirestoreArray(List data) {
    final List<Map<String, dynamic>> result = [];

    for (var item in data) {
      if (item is String) {
        result.add({'stringValue': item});
      } else if (item is int) {
        result.add({'integerValue': item.toString()});
      } else if (item is double) {
        result.add({'doubleValue': item});
      } else if (item is bool) {
        result.add({'booleanValue': item});
      }
    }

    return result;
  }

  // Convert a Map to Firestore format
  Map<String, dynamic> _convertToFirestoreMap(Map data) {
    final Map<String, dynamic> result = {};

    data.forEach((key, value) {
      if (value is String) {
        result[key.toString()] = {'stringValue': value};
      } else if (value is int) {
        result[key.toString()] = {'integerValue': value.toString()};
      } else if (value is double) {
        result[key.toString()] = {'doubleValue': value};
      } else if (value is bool) {
        result[key.toString()] = {'booleanValue': value};
      }
    });

    return result;
  }

  // Get all items from a collection
  Future<List<Map<String, dynamic>>> getItems(String collection) async {
    try {
      print('Getting items from $collection using REST API'); // Debug print
      final response = await http.get(Uri.parse(_getCollectionUrl(collection)));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['documents'] != null) {
          return List<Map<String, dynamic>>.from(
            data['documents'].map((doc) => _convertFirestoreDocument(doc)),
          );
        } else {
          return [];
        }
      } else {
        print('Error getting items: ${response.statusCode}'); // Debug print
        print('Error body: ${response.body}'); // Debug print
        throw Exception('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting items: $e'); // Debug print
      throw e;
    }
  }

  // Get a single item by ID
  Future<Map<String, dynamic>?> getItemById(
    String collection,
    String id,
  ) async {
    try {
      print('Getting item by ID: $id from $collection'); // Debug print
      final response = await http.get(
        Uri.parse(_getDocumentUrl(collection, id)),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _convertFirestoreDocument(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        print('Error getting item: ${response.statusCode}'); // Debug print
        print('Error body: ${response.body}'); // Debug print
        throw Exception('Failed to load item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting item: $e'); // Debug print
      throw e;
    }
  }

  // Add a new item
  Future<String> addItem(String collection, Map<String, dynamic> item) async {
    try {
      print('Adding item to $collection'); // Debug print
      final response = await http.post(
        Uri.parse(_getCollectionUrl(collection)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_convertToFirestoreDocument(item)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final String docId = data['name'].split('/').last;
        print('Item added successfully with ID: $docId'); // Debug print
        return docId;
      } else {
        print('Error adding item: ${response.statusCode}'); // Debug print
        print('Error body: ${response.body}'); // Debug print
        throw Exception('Failed to add item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding item: $e'); // Debug print
      throw e;
    }
  }

  // Update an item
  Future<void> updateItem(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      print('Updating item with ID: $id in $collection'); // Debug print

      // For update, we need patch
      final response = await http.patch(
        Uri.parse(_getDocumentUrl(collection, id)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_convertToFirestoreDocument(data)),
      );

      if (response.statusCode == 200) {
        print('Item updated successfully'); // Debug print
      } else {
        print('Error updating item: ${response.statusCode}'); // Debug print
        print('Error body: ${response.body}'); // Debug print
        throw Exception('Failed to update item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating item: $e'); // Debug print
      throw e;
    }
  }

  // Delete an item
  Future<void> deleteItem(String collection, String id) async {
    try {
      print('Deleting item with ID: $id from $collection'); // Debug print
      final response = await http.delete(
        Uri.parse(_getDocumentUrl(collection, id)),
      );

      if (response.statusCode == 200) {
        print('Item deleted successfully'); // Debug print
      } else {
        print('Error deleting item: ${response.statusCode}'); // Debug print
        print('Error body: ${response.body}'); // Debug print
        throw Exception('Failed to delete item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting item: $e'); // Debug print
      throw e;
    }
  }
}
