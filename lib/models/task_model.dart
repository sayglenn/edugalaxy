import 'package:edugalaxy/pages/tasks.dart';

class Task {
  String? title;
  DateTime? dueDate;
  int? hours;
  int? minutes;
  Priority? priority;

  Task({
    required this.title,
    required this.dueDate,
    required this.hours,
    required this.minutes,
    required this.priority,
  });
}
