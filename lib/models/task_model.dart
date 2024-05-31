import 'package:edugalaxy/pages/tasks.dart';

class Task {
  String title;
  DateTime date;
  int timeToComplete;
  Priority priority;

  Task({
    required this.title,
    required this.date,
    required this.timeToComplete,
    required this.priority,
  });
}
