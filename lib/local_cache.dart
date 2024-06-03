class LocalCache {
    static String uid = '';

    static void set_uid(String _uid) {
        uid = _uid;
    }
//   static Map? _data = {};

//   static void setData(Map? data) {
//     _data = data;
//   }

//   static void createData(String path, dynamic value) {
//     List<String> pathSegments = path.split('/');
//     Map? currentLevel = _data;

//     if (pathSegments.length == 0 || currentLevel == null) {
//         return;
//     } else {
//         for (int i = 0; i < pathSegments.length; i++) {
//             String segment = pathSegments[i];

//             if (currentLevel[segment] == null) {
//                 return;
//             }
//             // if (i == pathSegments.length - 1) {
//             //     currentLevel[segment] = value;
//             // } else {
//             //     if (currentLevel[segment] == null) {
//             //     currentLevel[segment] = {};
//             //     }
//             //     currentLevel = currentLevel[segment];
//             // }
//         }
//     }
//   }

//   static dynamic readData(String path) {
//     List<String> pathSegments = path.split('/');
//     Map? currentLevel = _data;

//     if (pathSegments.length == 0 || currentLevel == null) {
//         return;
//     } else {
//         for (int i = 0; i < pathSegments.length; i++) {
//             String segment = pathSegments[i];

//             if (i == pathSegments.length - 1) {
//                 return currentLevel[segment];
//             } else {
//                 if (currentLevel[segment] == null) {
//                 return null;
//                 }
//                 currentLevel = currentLevel[segment];
//             }
//         }
//     }

//   }

//   static void printData() {
//     print(_data);
//   }
}