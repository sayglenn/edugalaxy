import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase database;

  DatabaseService({FirebaseDatabase? database})
      : database = database ?? FirebaseDatabase.instance;

  // Create data
  Future<void> createData(String path, dynamic data,
      {bool isPush = false}) async {
    DatabaseReference ref = database.ref(path);
    if (isPush) {
      await ref.push().set(data);
    } else {
      print('create');
      await ref.set(data);
    }
  }

  // Read data
  Future<Map?> readData(String path) async {
    DatabaseReference ref = database.ref(path);
    DataSnapshot snapshot = await ref.get();
    return snapshot.value as Map?;
  }

  // Update data
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    DatabaseReference ref = database.ref(path);
    try {
      print('Updating data at $path with data: $data');
      await ref.update(data);
      print('Data update successful at $path');
    } catch (e) {
      print('Error updating data at $path: $e');
    }
  }

  // Delete data
  Future<void> deleteData(String path) async {
    DatabaseReference ref = database.ref(path);
    await ref.remove();
  }

  // Check if data exists
  Future<bool> dataExists(String path, String dataKey) async {
    DatabaseReference ref = database.ref('$path/$dataKey');
    DataSnapshot snapshot = await ref.get();
    return snapshot.exists;
  }
}
