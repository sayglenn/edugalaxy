import 'package:edugalaxy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:edugalaxy/local_cache.dart';

class SessionCreator extends StatefulWidget {
  const SessionCreator({super.key});

  @override
  State<SessionCreator> createState() => _SessionCreatorState();
}

class _SessionCreatorState extends State<SessionCreator> {
  double _currentHours = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _currentHours,
          min: 1,
          max: 8,
          divisions: 7,
          label: _currentHours.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentHours = value;
            });
          },
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SessionPage(sessionDuration: _currentHours.round())),
            );
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

class SessionPage extends StatefulWidget {
  final int sessionDuration;

  const SessionPage({super.key, required this.sessionDuration});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Navigator.pop(context);
      print("You exited the application!");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrokenSession(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  Navigator.pop(context);
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
  const BrokenSession({super.key});

  @override
  Widget build(BuildContext context) {
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
                  "You left the application and the session was ended!",
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
