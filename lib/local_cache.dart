import 'package:edugalaxy/database_functions.dart';

class LocalCache {
  static String uid = '';
  static Map<String, Map<String, dynamic>> tasksCache = {};
  static bool autoClick = false;

  static void set_uid(String _uid) {
    uid = _uid;
  }

  static Future<void> fetchAndCacheTasks() async {
    if (uid.isEmpty) {
      print('User ID is not set.');
      return;
    }

    try {
      Map? tasksMap = await DatabaseService.readData('Tasks');

      tasksCache.clear(); // Clear any previous cache

      if (tasksMap != null) {
        tasksMap.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> task = Map<String, dynamic>.from(value);
            if (task['User'] == uid) {
              tasksCache[key] = task;
            }
          }
        });
      }

      print('Tasks cached successfully.');
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  static List<Map<String, dynamic>> getCachedTasks() {
    return tasksCache.values.toList();
  }

  static Future<void> addTask(String? _title, Map<String, dynamic> task) async {
    if (uid.isEmpty) {
      print('User ID is not set.');
      return;
    }

    try {
      await DatabaseService.updateData('Tasks', {'${_title}': task});

      // Retrieve the tasks again to update the cache
      await fetchAndCacheTasks();

      print('Task added successfully.');
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  static List<Map<String, dynamic>> sortTasks(
      List<Map<String, dynamic>> tasks) {
    tasks.sort((a, b) {
      int dateComparison =
          DateTime.parse(a['dueDate']).compareTo(DateTime.parse(b['dueDate']));
      int firstPriority = a['priority'] == "Low"
          ? 1
          : a['priority'] == "Medium"
              ? 2
              : 3;
      int secondPriority = b['priority'] == "Low"
          ? 1
          : a['priority'] == "Medium"
              ? 2
              : 3;
      if (dateComparison != 0) {
        return dateComparison;
      } else {
        return firstPriority - secondPriority;
      }
    });
    return tasks;
  }
}
