// class LocalCache {
//     static String uid = '';

//     static void set_uid(String _uid) {
//         uid = _uid;
//     }
// //   static Map? _data = {};

// //   static void setData(Map? data) {
// //     _data = data;
// //   }

// //   static void createData(String path, dynamic value) {
// //     List<String> pathSegments = path.split('/');
// //     Map? currentLevel = _data;

// //     if (pathSegments.length == 0 || currentLevel == null) {
// //         return;
// //     } else {
// //         for (int i = 0; i < pathSegments.length; i++) {
// //             String segment = pathSegments[i];

// //             if (currentLevel[segment] == null) {
// //                 return;
// //             }
// //             // if (i == pathSegments.length - 1) {
// //             //     currentLevel[segment] = value;
// //             // } else {
// //             //     if (currentLevel[segment] == null) {
// //             //     currentLevel[segment] = {};
// //             //     }
// //             //     currentLevel = currentLevel[segment];
// //             // }
// //         }
// //     }
// //   }

// //   static dynamic readData(String path) {
// //     List<String> pathSegments = path.split('/');
// //     Map? currentLevel = _data;

// //     if (pathSegments.length == 0 || currentLevel == null) {
// //         return;
// //     } else {
// //         for (int i = 0; i < pathSegments.length; i++) {
// //             String segment = pathSegments[i];

// //             if (i == pathSegments.length - 1) {
// //                 return currentLevel[segment];
// //             } else {
// //                 if (currentLevel[segment] == null) {
// //                 return null;
// //                 }
// //                 currentLevel = currentLevel[segment];
// //             }
// //         }
// //     }

// //   }

// //   static void printData() {
// //     print(_data);
// //   }
// }

import 'package:edugalaxy/database_functions.dart';

class LocalCache {
  static String uid = '';
  static Map<String, Map<String, dynamic>> tasksCache = {};

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
      
      tasksCache.clear();  // Clear any previous cache

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
      await DatabaseService.updateData(
                  'Tasks', {'${_title}': task});
      
      // Retrieve the tasks again to update the cache
      await fetchAndCacheTasks();
      
      print('Task added successfully.');
    } catch (e) {
      print('Error adding task: $e');
    }
  }
}
