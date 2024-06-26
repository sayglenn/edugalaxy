import 'package:flutter/material.dart';

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
          onPressed: () {},
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
