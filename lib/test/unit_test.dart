import 'package:edugalaxy/pages/home.dart';
import 'package:edugalaxy/pages/session.dart';
import 'package:edugalaxy/pages/tasks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
