import 'package:edugalaxy/pages/tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:edugalaxy/database_functions.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';

void main() {
  group("Firebase CRUD functions", () {
    // Initialise mock databases and services.
    FirebaseDatabase database = MockFirebaseDatabase.instance;
    DatabaseService databaseService = DatabaseService(database: database);

    test("createData sets data correctly", () async {
      // Insert data, then retrieve the snapshot.
      await databaseService.createData("Test", {'key': 'value'});
      DatabaseReference ref = database.ref('Test');
      DataSnapshot snapshot = await ref.get();

      // Data should be inserted correctly.
      expect(snapshot.value, {'key': 'value'});
    });

    test("readData reads data correctly", () async {
      await databaseService.createData("Test", {'key': 'value'});
      Map? data = await databaseService.readData("Test");

      // Data should correspond with the inserted data.
      expect(data, {'key': 'value'});
    });

    test("updateData updates data correctly", () async {
      await databaseService.createData("Test", {'key1': 'value1'});
      DataSnapshot snapshot = await database.ref('Test').get();

      // Data before update should be { key1: value1 }
      expect(snapshot.value, {'key1': 'value1'});

      // Perform the function then update the snapshot.
      await databaseService.updateData("Test", {'key2': 'value2'});
      snapshot = await database.ref('Test').get();

      // New data should contain both sets of KV-pairs.
      expect(snapshot.value, {
        'key1': 'value1',
        'key2': 'value2',
      });
    });

    test("deleteData deletes data correctly", () async {
      await databaseService.createData("Test", {'key': 'value'});
      DataSnapshot snapshot = await database.ref('Test').get();

      // Data before update should exist.
      expect(snapshot.value, {'key': 'value'});

      // Perform the function then update the snapshot.
      await databaseService.deleteData('Test');
      snapshot = await database.ref('Test').get();

      // Data should no longer exist.
      expect(snapshot.value, null);
    });

    test("dataExists returns correctly", () async {
      await databaseService.createData("Test", {'key': 'value'});

      // Data should exist in the database.
      expect(await databaseService.dataExists("Test", 'key'), true);

      // Perform the function then update the snapshot.
      await databaseService.deleteData('Test');

      // Data should no longer exist.
      expect(await databaseService.dataExists("Test", 'key'), false);
    });
  });

  test('Form options reset correctly', () {
    // Initialise TasksPageState
    final TasksPageState tasksPageState = TasksPageState();
    tasksPageState.title = 'Test';
    tasksPageState.date = DateTime.now();
    tasksPageState.hours = 1;
    tasksPageState.minutes = 30;
    tasksPageState.priority = 1;

    // Reset options and ensure that all values are null
    tasksPageState.resetOptions();
    expect(tasksPageState.title, null);
    expect(tasksPageState.date, null);
    expect(tasksPageState.hours, null);
    expect(tasksPageState.minutes, null);
    expect(tasksPageState.priority, null);
  });
}
