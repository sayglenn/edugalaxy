import 'package:edugalaxy/models/task_model.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        height: 600,
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
                                  _fieldHeader("Title"),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                        hintText: 'Reminder Name',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  _fieldHeader("Due Date"),
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

  Padding _fieldHeader(String fieldHeader) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        bottom: 4.0,
      ),
      child: Text(
        fieldHeader,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
