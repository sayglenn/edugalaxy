import 'package:date_field/date_field.dart';
import 'package:edugalaxy/database_functions.dart';
import 'package:edugalaxy/local_cache.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// enum Priority { low, medium, high }

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _title;
  DateTime? _date;
  int? _hours;
  int? _minutes;
  int? _priority;
  Future<List<Map<String, dynamic>>>? _incompleteTasks;
  Future<List<Map<String, dynamic>>>? _completedTasks;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    if (LocalCache.autoClick) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTaskCreationSheet(context);
      });
    }
    LocalCache.autoClick = false;
  }

  void _fetchTasks() {
    // Fetch tasks for the current user
    setState(() {
      _incompleteTasks = Future.value(LocalCache.getCachedTasks() ?? []);
      _incompleteTasks!.then((tasks) {
        print("Incomplete Tasks: $tasks");
      });
      _completedTasks = Future.value(LocalCache.getCompletedTasks() ?? []);
      _completedTasks!.then((tasks) {
        print("Completed Tasks: $tasks");
      });
      print('Tasks fetched and set');
    });
  }

  void reset_options() {
    _title = null;
    _date = null;
    _hours = null;
    _minutes = null;
    _priority = null;
  }

  Future<void> _showTaskCreationSheet(BuildContext context) async {
    reset_options();
    final result = await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: Color.fromARGB(255, 206, 238, 255),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Create Task",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 36,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleField(),
                        _dueDateField(),
                        _priorityField(),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: _hoursField(),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: _minutesField(),
                            )
                          ],
                        ),
                        _submitTask(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result == true) {
      print('Task creation successful, fetching tasks');
      _fetchTasks();
    }
  }

  Future<void> _showEditTaskSheet(
      BuildContext context, Map<String, dynamic> task) async {
    _formKey.currentState?.reset();

    setState(() {
      _title = task['title'];
      _date = DateTime.parse(task['dueDate']);
      _hours = task['hours'];
      _minutes = task['minutes'];
      _priority = task['priority'] == "Low"
          ? 1
          : task['priority'] == "Medium"
              ? 2
              : 3;
    });

    final result = await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: Color.fromARGB(255, 206, 238, 255),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Edit Task",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 36,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleField(),
                        _dueDateField(),
                        _priorityField(),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: _hoursField(),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: _minutesField(),
                            )
                          ],
                        ),
                        _submitTask(context,
                            isEdit: true, originalTitle: task['title']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result == true) {
      _fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          tabs: [
            Tab(text: "Incomplete Tasks"),
            Tab(text: "Completed Tasks"),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildTaskList(_incompleteTasks),
                  _buildTaskList(_completedTasks),
                ],
              ),
            ),
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    onPressed: () => _showTaskCreationSheet(context),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(Future<List<Map<String, dynamic>>>? tasksFuture) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading tasks'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No tasks'));
        } else {
          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final dueDate = task['completedAt'] != null
                  ? DateTime.parse(task['completedAt'])
                  : DateTime.parse(task['dueDate']);
              final formattedDate = dueDate != null
                  ? DateFormat('yyyy-MM-dd – hh:mm a').format(dueDate)
                  : 'No due date';
              Color taskColour = task['completedAt'] != null
                  ? Colors.transparent
                  : task['priority'] == "Low"
                      ? Colors.green
                      : task['priority'] == "Medium"
                          ? Color.fromARGB(255, 254, 190, 41)
                          : Colors.red;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card.outlined(
                  color: dueDate.compareTo(DateTime.now()) < 0 &&
                          task['completedAt'] == null
                      ? Color.fromARGB(255, 255, 224, 227)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: taskColour, width: 2.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${task['title']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        dueDate.compareTo(DateTime.now()) < 0 &&
                                                task['completedAt'] == null
                                            ? Colors.red
                                            : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "  (${task['hours']}h ${task['minutes']}min)",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: tasksFuture == _incompleteTasks
                        ? Text('Due: $formattedDate')
                        : Text('Completed: $formattedDate'),
                    trailing: tasksFuture == _incompleteTasks
                        ? Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  _showEditTaskSheet(context, task),
                              iconSize: 16.0,
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () => _completeTask(task),
                            ),
                          ])
                        : IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteTask(task),
                          ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> _deleteTask(Map<String, dynamic> task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
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
      // Mark task as completed and refresh tasks
      await LocalCache.deleteTask(task['title'], task);
      _fetchTasks();
    }
  }

  Future<void> _completeTask(Map<String, dynamic> task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Complete Task'),
          content: Text('Are you sure you want to complete this task?'),
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
      // Mark task as completed and refresh tasks
      await LocalCache.deleteTask(task['title'], task, complete: true);
      _fetchTasks();
    }
  }

  Row _submitTask(BuildContext context,
      {bool isEdit = false, String? originalTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 154, 255, 158),
            ),
            child: const Text(
              "Submit",
              style: TextStyle(color: Color.fromARGB(255, 50, 128, 53)),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                String? dateString = _date?.toIso8601String();
                Map<int, String> priorityDict = {
                  1: "Low",
                  2: "Medium",
                  3: "High",
                };
                final Map<String, dynamic> task = {
                  "User": LocalCache.uid,
                  "title": _title,
                  "dueDate": dateString,
                  "hours": _hours,
                  "minutes": _minutes,
                  "priority": priorityDict[_priority],
                };

                if (isEdit && originalTitle != null) {
                  await LocalCache.updateTask(originalTitle, task);
                } else {
                  await LocalCache.addTask(_title, task);
                }

                Navigator.pop(context, true);
                print(
                    'Task ${isEdit ? 'updated' : 'added'} and returning true');
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _priorityField() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: DropdownButtonFormField<int?>(
        value: _priority,
        decoration: InputDecoration(
          labelText: "Priority *",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: 1,
            child: Text("Low"),
          ),
          DropdownMenuItem(
            value: 2,
            child: Text("Medium"),
          ),
          DropdownMenuItem(
            value: 3,
            child: Text("High"),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _priority = value;
          });
        },
        onSaved: (value) {
          setState(() {
            _priority = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return "Required";
          }
          return null;
        },
      ),
    );
  }

  Widget _minutesField() {
    // return Padding(
    //   padding: const EdgeInsets.only(
    //     left: 4.0,
    //     right: 4.0,
    //   ),
    //   child:
    return DropdownButtonFormField<int>(
      value: _minutes,
      padding: const EdgeInsets.only(
        top: 32.0,
        left: 8.0,
        right: 16.0,
      ),
      decoration: InputDecoration(
        labelText: "Minutes *",
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: 0,
          child: Text("0 minutes"),
        ),
        DropdownMenuItem(
          value: 15,
          child: Text("15 minutes"),
        ),
        DropdownMenuItem(
          value: 30,
          child: Text("30 minutes"),
        ),
        DropdownMenuItem(
          value: 45,
          child: Text("45 minutes"),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _minutes = value;
        });
      },
      onSaved: (value) {
        setState(() {
          _minutes = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return "Required";
        }
        if (_hours == 0 && value == 0) {
          return "Minimum 15 minutes";
        }
        return null;
      },
      //),
    );
  }

  Widget _hoursField() {
    // return Padding(
    //   padding: const EdgeInsets.only(
    //     left: 16.0,
    //     right: 4.0,
    //   ),
    //   child:
    return DropdownButtonFormField<int>(
      value: _hours,
      padding: const EdgeInsets.only(
        top: 32.0,
        left: 16.0,
        right: 8.0,
      ),
      decoration: InputDecoration(
        labelText: "Hours *",
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      items: List.generate(
          9,
          (index) => DropdownMenuItem(
                value: index,
                child: Text('${index} hour${index <= 1 ? "" : "s"}'),
              )),
      validator: (value) {
        if (value == null) {
          return "Required";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _hours = value;
        });
      },
      onSaved: (value) {
        setState(() {
          _hours = value;
        });
      },
      //),
    );
  }

  Padding _dueDateField() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 32.0,
      ),
      child: DateTimeFormField(
        onChanged: (value) {
          setState(() {
            _date = value;
          });
        },
        onSaved: (value) {
          setState(() {
            _date = value;
          });
        },
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        decoration: InputDecoration(
          labelText: "Due Date *",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'When is the task due?',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null) {
            return "Required";
          }
          return null;
        },
      ),
    );
  }

  Padding _titleField() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: 32.0,
      ),
      child: TextFormField(
        initialValue: _title,
        decoration: InputDecoration(
          labelText: "Title *",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'What will you name your task?',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Required";
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            _title = value;
          });
        },
        onSaved: (value) {
          setState(() {
            _title = value;
          });
        },
      ),
    );
  }
}
