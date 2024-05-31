import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static final DatabaseReference _database = FirebaseDatabase.instance.reference();

  // Create data
  static Future<void> createData(String path, dynamic data, {bool isPush = false}) async {
    DatabaseReference ref = _database.child(path);
    if (isPush) {
      await ref.push().set(data);
    } else {
      await ref.set(data);
    }
  }

  // Read data
  static Future<Map?> readData(String path) async {
    DatabaseReference ref = _database.child(path);
    DataSnapshot snapshot = await ref.get();
    return snapshot.value as Map?;
  }

  // Update data
  static Future<void> updateData(String path, Map<String, dynamic> data) async {
    DatabaseReference ref = _database.child(path);
    await ref.update(data);
  }

  // Delete data
  static Future<void> deleteData(String path) async {
    DatabaseReference ref = _database.child(path);
    await ref.remove();
  }

  // Check if data exists
  static Future<bool> dataExists(String path, String dataKey) async {
    DatabaseReference ref = _database.child('$path/$dataKey');
    DataSnapshot snapshot = await ref.get();
    return snapshot.exists;
  }
}
