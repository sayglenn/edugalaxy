import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  // Create data
  static Future<void> createData(String path, dynamic data, {bool isPush = false}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    if (isPush) {
      await ref.push().set(data);
    } else {
        print('create');
      await ref.set(data);
    }
  }

  // Read data
  static Future<Map?> readData(String path) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    DataSnapshot snapshot = await ref.get();
    return snapshot.value as Map?;
  }

  // Update data
  static Future<void> updateData(String path, Map<String, dynamic> data) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    try {
      print('Updating data at $path with data: $data');
      await ref.update(data);
      print('Data update successful at $path');
    } catch (e) {
      print('Error updating data at $path: $e');
    }
  }

  // Delete data
  static Future<void> deleteData(String path) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    await ref.remove();
  }

  // Check if data exists
  static Future<bool> dataExists(String path, String dataKey) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('$path/$dataKey');
    DataSnapshot snapshot = await ref.get();
    return snapshot.exists;
  }
}
