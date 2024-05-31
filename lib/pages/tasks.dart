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
    int? timeToComplete;
    Priority? priority = Priority.medium;

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
                        height: 475,
                        color: Color.fromARGB(255, 206, 238, 255),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
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
                                  Padding(
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
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                        hintText:
                                            'What will you name your task?',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please input a title";
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        title = value;
                                      },
                                    ),
                                  ),
                                  Padding(
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
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                        hintText: 'When is the task due?',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      bottom: 32.0,
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Duration *",
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                        hintText:
                                            'How long does your task need?',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                    ),
                                    child: SegmentedButton(
                                      segments: [
                                        ButtonSegment(
                                          value: Priority.low,
                                          label: Text("Low"),
                                        ),
                                        ButtonSegment(
                                          value: Priority.medium,
                                          label: Text("Medium"),
                                        ),
                                        ButtonSegment(
                                            value: Priority.high,
                                            label: Text("High"))
                                      ],
                                      selected: {priority},
                                    ),
                                  ),
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
}
