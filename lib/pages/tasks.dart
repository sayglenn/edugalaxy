import 'package:date_field/date_field.dart';
import 'package:edugalaxy/models/task_model.dart';
import 'package:edugalaxy/database_functions.dart';
import 'package:edugalaxy/local_cache.dart';
import 'package:flutter/material.dart';

enum Priority { low, medium, high }

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.blue,
            width: double.infinity,
          ),
        ),
        Row(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          color: Color.fromARGB(255, 206, 238, 255),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _hoursField(),
                                        ),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: _minutesField()
                                        ),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: _priorityField(),
                                        ),
                                      ],
                                    ),
                                    _submitTask(context)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      );
                    },
                  );
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row _submitTask(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 16.0,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 154, 255, 158),
            ),
            child: const Text(
              "Submit",
              style: TextStyle(color: Color.fromARGB(255, 50, 128, 53)),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                String? dateString = _date?.toIso8601String();
                Map<int, String> priorityDict = {
                  1: "Low",
                  2: "Medium",
                  3: "High"
                };
                final Map<String, dynamic> task = {
                  "title": _title,
                  "dueDate": dateString,
                  "hours": _hours,
                  "minutes": _minutes,
                  "priority": priorityDict[_priority],
                };
                
                String uid = LocalCache.uid;
                DatabaseService.updateData(
                  'Users/${uid}/Tasks', {'${_title}': task});
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _priorityField() {
    // return Padding(
    //   padding: const EdgeInsets.only(
    //     left: 4.0,
    //     right: 16.0,
    //   ),
    //  child: 
    return DropdownButtonFormField<int?>(
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
      //),
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
          8,
          (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1} hour${index + 1 == 1 ? "" : "s"}'),
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
