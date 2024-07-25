import 'package:edugalaxy/database_functions.dart';

class LocalCache {
  static String uid = '';
  static Map<String, Map<String, dynamic>> tasksCache = {};
  static Map<String, Map<String, dynamic>> completedTasksCache = {};
  static Map<String, dynamic> userInfo = {};
  static bool autoClick = false;
  static DatabaseService databaseService = DatabaseService();

  static void set_uid(String _uid) {
    uid = _uid;
  }

  static void clear_cache() {
    tasksCache.clear();
    completedTasksCache.clear();
    userInfo.clear();
  }

  static Future<void> fetchAndCacheTasks() async {
    if (uid.isEmpty) {
      print('User ID is not set.');
      return;
    }

    try {
      Map? tasksMap = await databaseService.readData('Tasks');

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

      Map? completedTasksMap = await databaseService.readData('CompletedTasks');

      completedTasksCache.clear(); // Clear any previous cache

      if (completedTasksMap != null) {
        completedTasksMap.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> task = Map<String, dynamic>.from(value);
            if (task['User'] == uid) {
              completedTasksCache[key] = task;
            }
          }
        });
      }

      Map? _userInfo = await databaseService.readData('Users/${uid}');
      if (_userInfo != null) {
        userInfo = Map<String, dynamic>.from(_userInfo);
      }

      print('Tasks cached successfully.');
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  static List<Map<String, dynamic>> getCachedTasks() {
    // returns sorted task list
    return sortTasks(tasksCache.values.toList());
  }

  static List<Map<String, dynamic>> getCompletedTasks() {
    return sortTasks(completedTasksCache.values.toList(), completed: true);
  }

  static Future<void> addTask(String? _title, Map<String, dynamic> task) async {
    if (uid.isEmpty) {
      print('User ID is not set.');
      return;
    }

    try {
      await databaseService.updateData('Tasks', {'${_title}': task});

      // Directly update the local cache
      tasksCache[_title!] = task;

      // Print to confirm the addition
      print('Task added and cache updated successfully.');
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  static Future<void> deleteTask(String? _title, Map<String, dynamic> task,
      {bool complete = false}) async {
    if (uid.isEmpty) {
      print('User ID is not set.');
      return;
    }

    try {
      if (complete) {
        // remove task from current tasks and add to completed tasks
        // delete from task database
        await databaseService.deleteData('Tasks/${_title}');

        task['completedAt'] = DateTime.now().toIso8601String();

        // add to completed tasks
        await databaseService.updateData('CompletedTasks', {'${_title}': task});

        // directly removes from local cache
        tasksCache.remove(_title!);

        // add to completed tasks cache
        completedTasksCache[_title!] = task;

        // Print to confirm the completion
        print('Task completed and cache updated successfully.');
      } else {
        // delete from task database
        await databaseService.deleteData('Tasks/${_title}');
        await databaseService.deleteData('CompletedTasks/${_title}');

        // directly removes from local cache
        tasksCache.remove(_title!);
        completedTasksCache.remove(_title!);

        // Print to confirm the deletion
        print('Task deleted and cache updated successfully.');
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  static Future<void> updateTask(
      String? _title, Map<String, dynamic> task) async {
    await databaseService.deleteData('Tasks/${_title}');
    tasksCache.remove(_title!);
    String? newTitle = task['title'];
    await databaseService.updateData('Tasks/${newTitle}', task);
    tasksCache[newTitle!] = task;
  }

  static List<Map<String, dynamic>> sortTasks(List<Map<String, dynamic>> tasks,
      {completed = false}) {
    tasks.sort((a, b) {
      int dateComparison = (completed)
          ? DateTime.parse(b['completedAt'])
              .compareTo(DateTime.parse(a['completedAt']))
          : DateTime.parse(a['dueDate'])
              .compareTo(DateTime.parse(b['dueDate']));
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
        return secondPriority - firstPriority;
      }
    });
    return tasks;
  }

  static Future<void> updateUserInfo(Map<String, dynamic> newUserInfo) async {
    if (uid.isEmpty) {
      print('User ID is not set.');
      return;
    }
    try {
      userInfo = newUserInfo;
      await databaseService.updateData('Users/${uid}', newUserInfo);
    } catch (e) {
      print('Error updating user information: $e');
    }
  }
}
