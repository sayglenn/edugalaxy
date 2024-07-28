// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
// import 'package:edugalaxy/local_cache.dart';

// Map<int, String> planetNames = {
//   1: "earth",
//   2: "sci-fi",
// };

// class SessionCreator extends StatefulWidget {
//   const SessionCreator({super.key});

//   @override
//   State<SessionCreator> createState() => SessionCreatorState();
// }

// class SessionCreatorState extends State<SessionCreator> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   double currentHours = 4;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Slider(
//           value: currentHours,
//           min: 1,
//           max: 8,
//           divisions: 7,
//           label: currentHours.round().toString(),
//           onChanged: (double value) {
//             setState(() {
//               currentHours = value;
//             });
//           },
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (_formKey.currentState!.validate()) {
//                 _formKey.currentState!.save();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         SessionPage(sessionDuration: currentHours.round())),
//               );
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color.fromARGB(255, 154, 255, 158),
//           ),
//           child: Text(
//             "Submit",
//             style: TextStyle(
//               color: Color.fromARGB(255, 50, 128, 53),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class PlanetImage extends StatefulWidget {
//   final int totalSeconds;
//   final String planetName;

//   PlanetImage({
//     super.key,
//     required this.totalSeconds,
//     required this.planetName,
//   });

//   @override
//   State<PlanetImage> createState() => _PlanetImageState();
// }

// class _PlanetImageState extends State<PlanetImage> {
//   Timer? timer;
//   int elapsedSeconds = 0;

//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
//       setState(() {
//         elapsedSeconds += 1;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     int imageIndex = (elapsedSeconds / (widget.totalSeconds / 4)).floor() + 1;
//     AssetImage planetImage =
//         AssetImage('lib/assets/${widget.planetName}/$imageIndex.jpg');

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(500),
//       child: Image(
//         image: planetImage,
//         height: 110,
//         width: 110,
//       ),
//     );
//   }
// }

// class SessionPage extends StatefulWidget {
//   final int sessionDuration;

//   const SessionPage({super.key, required this.sessionDuration});

//   @override
//   State<SessionPage> createState() => SessionPageState();
// }

// class SessionPageState extends State<SessionPage>
//     with WidgetsBindingObserver, SingleTickerProviderStateMixin {
//   static List<Map<String, dynamic>> filteredTasks = [];
//   late AnimationController _controller;
//   late Animation<double> _planetAnimation;
//   late Animation<double> _shadowAnimation;

//   void deleteTasks(List<Map<String, dynamic>> filteredTasks) {
//     filteredTasks.forEach((task) {
//       LocalCache.deleteTask(task['title'], task, complete: true);
//     });
//   }

//   Future<void> _endSession() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('End Session'),
//           content: Text(
//               'By ending the session, note that all tasks will be considered incomplete and your planet will be destroyed. Are you sure you want to end the session?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: Text('No'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirmed == true) {
//       await LocalCache.destroyPlanet();
//       Navigator.pop(context);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => BrokenSession(leftApp: false),
//         ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);

//     _planetAnimation =
//         Tween<double>(begin: 0, end: -15).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));

//     _shadowAnimation =
//         Tween<double>(begin: 70, end: 35).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       LocalCache.destroyPlanet();
//       Navigator.pop(context);
//       print("You exited the application!");
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => BrokenSession(leftApp: true),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String planetName = planetNames[LocalCache.currentSession['planetType']]!;

//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.amber,
//           title: Text(
//             "Study Session Ongoing",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: Container(
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 30,
//               ),
//               AnimatedBuilder(
//                 animation: _planetAnimation,
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(0, _planetAnimation.value),
//                     child: child,
//                   );
//                 },
//                 child: PlanetImage(
//                   totalSeconds: widget.sessionDuration * 60 * 60,
//                   planetName: planetName,
//                 ),
//               ),
//               AnimatedBuilder(
//                 animation: _shadowAnimation,
//                 builder: (context, child) {
//                   return Container(
//                     height: 1,
//                     width: _shadowAnimation.value,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 5,
//                           blurRadius: 7,
//                           offset: Offset(0, 3),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 115, 128, 201),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: TimerCountdown(
//                     format: CountDownTimerFormat.hoursMinutesSeconds,
//                     enableDescriptions: false,
//                     endTime: DateTime.now().add(
//                       Duration(
//                         hours: widget.sessionDuration,
//                       ),
//                     ),
//                     onEnd: () {
//                       deleteTasks(filteredTasks);
//                       LocalCache.completePlanet();
//                       Navigator.pop(
//                           context); //Can replace with display of final planet @glenn
//                     },
//                     colonsTextStyle: TextStyle(
//                       fontSize: 60,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     timeTextStyle: TextStyle(
//                       fontSize: 60,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               TaskPicker(
//                 sessionDuration: widget.sessionDuration,
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   await _endSession();
//                 },
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 255, 198, 194)),
//                 child: Text(
//                   "End Session",
//                   style: TextStyle(
//                     color: Colors.red,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TaskPicker extends StatelessWidget {
//   final Future<List<Map<String, dynamic>>> tasks;
//   final int sessionDuration;
//   //static final List<Map<String, dynamic>> filteredTasks = [];

//   TaskPicker({super.key, required this.sessionDuration})
//       : tasks = Future.value(LocalCache.getCachedTasks());

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: FutureBuilder<List<Map<String, dynamic>>>(
//         future: tasks,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error loading tasks'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No tasks available'));
//           } else {
//             final List<Map<String, dynamic>> tasks = snapshot.data!;
//             int minutes = sessionDuration * 60;
//             final List<Map<String, dynamic>> filteredTasks = [];
//             for (Map<String, dynamic> task in tasks) {
//               int taskDuration = task['hours'] * 60 + task['minutes'];
//               if (taskDuration <= minutes) {
//                 minutes -= taskDuration;
//                 filteredTasks.add(task);
//               }
//             }
//             SessionPageState.filteredTasks = filteredTasks;
//             Widget remainingTimeCard = minutes == 0
//                 ? SizedBox(
//                     height: 0,
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Card.outlined(
//                       color: Color.fromARGB(255, 115, 128, 201),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       elevation: 5,
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: ListTile(
//                           title: Text(
//                             "Free Time",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           trailing: Text(
//                             '${minutes ~/ 60} h ${minutes - minutes ~/ 60 * 60} min',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: const Color.fromARGB(255, 220, 220, 220),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );

//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredTasks.length,
//                     itemBuilder: (context, index) {
//                       final task = filteredTasks[index];
//                       Color taskColour = task['priority'] == "Low"
//                           ? Colors.green
//                           : task['priority'] == "Medium"
//                               ? Color.fromARGB(255, 254, 190, 41)
//                               : Colors.red;
//                       return Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Card.outlined(
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide(color: taskColour, width: 2.0),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           elevation: 5,
//                           child: Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: ListTile(
//                               title: Text(
//                                 task['title'],
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               trailing: Text(
//                                 '${task['hours']} h ${task['minutes']} min',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 remainingTimeCard,
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class BrokenSession extends StatelessWidget {
//   final bool leftApp;

//   const BrokenSession({super.key, required this.leftApp});

//   @override
//   Widget build(BuildContext context) {
//     String planet = planetNames[LocalCache.currentSession['planetType']]!;

//     ClipRRect destroyedPlanet = ClipRRect(
//       borderRadius: BorderRadius.circular(500),
//       child: Image(
//         image: AssetImage('lib/assets/destroyed.jpg'),
//         height: 110,
//         width: 110,
//       ),
//     );

//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(50.0),
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 destroyedPlanet,
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   "You broke your session!",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   (leftApp) ? "You left the application and the session was ended!"
//                             : "You have ended your session before the timer ran out!",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     "Return to Home",
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:edugalaxy/local_cache.dart';

Map<int, String> planetNames = {
  1: "earth",
  2: "sci-fi",
};

class SessionCreator extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const SessionCreator({super.key, required this.formKey});

  @override
  State<SessionCreator> createState() => SessionCreatorState();
}

class SessionCreatorState extends State<SessionCreator> {
  double currentHours = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: currentHours,
          min: 1,
          max: 8,
          divisions: 7,
          label: currentHours.round().toString(),
          onChanged: (double value) {
            setState(() {
              currentHours = value;
            });
          },
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.formKey.currentState!.validate()) {
              widget.formKey.currentState!.save();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SessionPage(sessionDuration: currentHours.round())),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 154, 255, 158),
          ),
          child: Text(
            "Submit",
            style: TextStyle(
              color: Color.fromARGB(255, 50, 128, 53),
            ),
          ),
        )
      ],
    );
  }
}

class PlanetImage extends StatefulWidget {
  final int totalSeconds;
  final String planetName;

  PlanetImage({
    super.key,
    required this.totalSeconds,
    required this.planetName,
  });

  @override
  State<PlanetImage> createState() => _PlanetImageState();
}

class _PlanetImageState extends State<PlanetImage> {
  Timer? timer;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        elapsedSeconds += 1;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int imageIndex = (elapsedSeconds / (widget.totalSeconds / 4)).floor() + 1;
    AssetImage planetImage =
        AssetImage('lib/assets/${widget.planetName}/$imageIndex.jpg');

    return ClipRRect(
      borderRadius: BorderRadius.circular(500),
      child: Image(
        image: planetImage,
        height: 110,
        width: 110,
      ),
    );
  }
}

class SessionPage extends StatefulWidget {
  final int sessionDuration;

  const SessionPage({super.key, required this.sessionDuration});

  @override
  State<SessionPage> createState() => SessionPageState();
}

class SessionPageState extends State<SessionPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  static List<Map<String, dynamic>> filteredTasks = [];
  late AnimationController _controller;
  late Animation<double> _planetAnimation;
  late Animation<double> _shadowAnimation;

  void deleteTasks(List<Map<String, dynamic>> filteredTasks) {
    filteredTasks.forEach((task) {
      LocalCache.deleteTask(task['title'], task, complete: true);
    });
  }

  Future<void> _endSession() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('End Session'),
          content: Text(
              'By ending the session, note that all tasks will be considered incomplete and your planet will be destroyed. Are you sure you want to end the session?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await LocalCache.destroyPlanet();
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrokenSession(leftApp: false),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _planetAnimation =
        Tween<double>(begin: 0, end: -15).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _shadowAnimation =
        Tween<double>(begin: 70, end: 35).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      LocalCache.destroyPlanet();
      Navigator.pop(context);
      print("You exited the application!");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrokenSession(leftApp: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String planetName = planetNames[LocalCache.currentSession['planetType']]!;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber,
          title: Text(
            "Study Session Ongoing",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              AnimatedBuilder(
                animation: _planetAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _planetAnimation.value),
                    child: child,
                  );
                },
                child: PlanetImage(
                  totalSeconds: widget.sessionDuration * 60 * 60,
                  planetName: planetName,
                ),
              ),
              AnimatedBuilder(
                animation: _shadowAnimation,
                builder: (context, child) {
                  return Container(
                    height: 1,
                    width: _shadowAnimation.value,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 115, 128, 201),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TimerCountdown(
                    format: CountDownTimerFormat.hoursMinutesSeconds,
                    enableDescriptions: false,
                    endTime: DateTime.now().add(
                      Duration(
                        hours: widget.sessionDuration,
                      ),
                    ),
                    onEnd: () {
                      deleteTasks(filteredTasks);
                      LocalCache.completePlanet();
                      Navigator.pop(
                          context); //Can replace with display of final planet @glenn
                    },
                    colonsTextStyle: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    timeTextStyle: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TaskPicker(
                sessionDuration: widget.sessionDuration,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  await _endSession();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 198, 194)),
                child: Text(
                  "End Session",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskPicker extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> tasks;
  final int sessionDuration;
  //static final List<Map<String, dynamic>> filteredTasks = [];

  TaskPicker({super.key, required this.sessionDuration})
      : tasks = Future.value(LocalCache.getCachedTasks());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading tasks'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks available'));
          } else {
            final List<Map<String, dynamic>> tasks = snapshot.data!;
            int minutes = sessionDuration * 60;
            final List<Map<String, dynamic>> filteredTasks = [];
            for (Map<String, dynamic> task in tasks) {
              int taskDuration = task['hours'] * 60 + task['minutes'];
              if (taskDuration <= minutes) {
                minutes -= taskDuration;
                filteredTasks.add(task);
              }
            }
            SessionPageState.filteredTasks = filteredTasks;
            Widget remainingTimeCard = minutes == 0
                ? SizedBox(
                    height: 0,
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card.outlined(
                      color: Color.fromARGB(255, 115, 128, 201),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListTile(
                          title: Text(
                            "Free Time",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Text(
                            '${minutes ~/ 60} h ${minutes - minutes ~/ 60 * 60} min',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 220, 220, 220),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      Color taskColour = task['priority'] == "Low"
                          ? Colors.green
                          : task['priority'] == "Medium"
                              ? Color.fromARGB(255, 254, 190, 41)
                              : Colors.red;
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card.outlined(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: taskColour, width: 2.0),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListTile(
                              title: Text(
                                task['title'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                '${task['hours']} h ${task['minutes']} min',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                remainingTimeCard,
              ],
            );
          }
        },
      ),
    );
  }
}

class BrokenSession extends StatelessWidget {
  final bool leftApp;

  const BrokenSession({super.key, required this.leftApp});

  @override
  Widget build(BuildContext context) {
    String planet = planetNames[LocalCache.currentSession['planetType']]!;

    ClipRRect destroyedPlanet = ClipRRect(
      borderRadius: BorderRadius.circular(500),
      child: Image(
        image: AssetImage('lib/assets/destroyed.jpg'),
        height: 110,
        width: 110,
      ),
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                destroyedPlanet,
                SizedBox(
                  height: 15,
                ),
                Text(
                  "You broke your session!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  (leftApp) ? "You left the application and the session was ended!"
                            : "You have ended your session before the timer ran out!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Return to Home",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
