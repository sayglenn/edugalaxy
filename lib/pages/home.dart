import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.pink,
            ),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 224, 244, 255)),
                  onPressed: () {},
                  child: Text('Create Task')),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 205, 255, 206),
                  ),
                  onPressed: () {},
                  child: Text('Create Session'))
            ],
          )
        ],
      ),
    );
  }
}
