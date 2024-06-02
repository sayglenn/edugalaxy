import 'package:date_field/date_field.dart';
import 'package:edugalaxy/models/task_model.dart';
import 'package:flutter/material.dart';

enum Priority { low, medium, high }

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String? title;
    DateTime? date;
    int? hours;
    int? minutes;
    Priority? priority;

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
                      return Container(
                        width: double.infinity,
                        height: 470,
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
                                  _titleField(title),
                                  _dueDateField(date),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _hoursField(hours),
                                      ),
                                      SizedBox(
                                          width: 155,
                                          child: _minutesField(minutes)),
                                      Expanded(
                                        child: _priorityField(priority),
                                      ),
                                    ],
                                  ),
                                  _submitTask(_formKey, title, date, hours,
                                      minutes, priority, context)
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Row _submitTask(GlobalKey<FormState> _formKey, String? title, DateTime? date,
      int? hours, int? minutes, Priority? priority, BuildContext context) {
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
                final task = Task(
                  title: title,
                  dueDate: date,
                  hours: hours,
                  minutes: minutes,
                  priority: priority,
                );
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }

  Padding _priorityField(Priority? priority) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4.0,
        right: 16.0,
      ),
      child: DropdownButtonFormField<Priority>(
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
            value: Priority.low,
            child: Text("Low"),
          ),
          DropdownMenuItem(
            value: Priority.medium,
            child: Text("Medium"),
          ),
          DropdownMenuItem(
            value: Priority.high,
            child: Text("High"),
          ),
        ],
        onChanged: (value) {
          priority = value;
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

  Padding _minutesField(int? minutes) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4.0,
        right: 4.0,
      ),
      child: DropdownButtonFormField<int>(
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
          minutes = value;
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

  Padding _hoursField(int? hours) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 4.0,
      ),
      child: DropdownButtonFormField<int>(
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
        onChanged: (value) {
          hours = value;
        },
        validator: (value) {
          if (value == null) {
            return "Required";
          }
          return null;
        },
        onSaved: (value) {
          hours = value;
        },
      ),
    );
  }

  Padding _dueDateField(DateTime? date) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 32.0,
      ),
      child: DateTimeFormField(
        onChanged: (newDate) {
          date = newDate;
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

  Padding _titleField(String? title) {
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
        onSaved: (value) {
          title = value;
        },
      ),
    );
  }
}
