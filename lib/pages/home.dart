// import 'package:edugalaxy/pages/session.dart';
// import 'package:flutter/material.dart';
// import 'package:edugalaxy/pages/navbar.dart';
// import 'package:edugalaxy/local_cache.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   int? _selectedPlanetType;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: Column(
//         children: [
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               color: const Color.fromARGB(255, 255, 174, 201),
//             ),
//           ),
//           OverflowBar(
//             alignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextButton(
//                 style: TextButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 224, 244, 255)),
//                 onPressed: () {
//                   LocalCache.autoClick = true;
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => NavBar(),
//                     ),
//                   );
//                 },
//                 child: Text('Create Task'),
//               ),
//               TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 205, 255, 206),
//                 ),
//                 onPressed: () {
//                   showModalBottomSheet<void>(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return SingleChildScrollView(
//                         child: Container(
//                           padding: EdgeInsets.all(20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Center(
//                                 child: Text(
//                                   "Create a new session",
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               _planetType(),
//                               Padding(
//                                 padding: EdgeInsets.only(left: 24.0),
//                                 child: Text(
//                                   "Hours:",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               SessionCreator(),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 child: Text('Create Session'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _planetType() {
//     return Padding(
//       padding: const EdgeInsets.only(
//         left: 16.0,
//         right: 16.0,
//         bottom: 32.0,
//       ),
//       child: DropdownButtonFormField<int?>(
//         value: _selectedPlanetType,
//         decoration: InputDecoration(
//           labelText: "Planet Type *",
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.all(15),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         items: const [
//           DropdownMenuItem(
//             value: 1,
//             child: Text("Earth"),
//           ),
//           DropdownMenuItem(
//             value: 2,
//             child: Text("Sci-Fi"),
//           ),
//         ],
//         onChanged: (value) {
//           setState(() {
//             _selectedPlanetType = value;
//             LocalCache.currentSession['planetType'] = value;
//           });
//         },
//         onSaved: (value) {
//           setState(() {
//             _selectedPlanetType = value;
//             //print("Hi I am $value");
//             LocalCache.currentSession['planetType'] = value;
//           });
//         },
//         validator: (value) {
//           if (value == null) {
//             return "Required";
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }

import 'package:edugalaxy/pages/session.dart';
import 'package:flutter/material.dart';
import 'package:edugalaxy/pages/navbar.dart';
import 'package:edugalaxy/local_cache.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedPlanetType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 255, 174, 201),
            ),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 224, 244, 255)),
                onPressed: () {
                  LocalCache.autoClick = true;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavBar(),
                    ),
                  );
                },
                child: Text('Create Task'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 205, 255, 206),
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "Create a new session",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _planetType(),
                                Padding(
                                  padding: EdgeInsets.only(left: 24.0),
                                  child: Text(
                                    "Hours:",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SessionCreator(formKey: _formKey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text('Create Session'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _planetType() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 32.0,
      ),
      child: DropdownButtonFormField<int?>(
        value: _selectedPlanetType,
        decoration: InputDecoration(
          labelText: "Planet Type *",
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
            child: Text("Earth"),
          ),
          DropdownMenuItem(
            value: 2,
            child: Text("Sci-Fi"),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedPlanetType = value;
            LocalCache.currentSession['planetType'] = value;
          });
        },
        onSaved: (value) {
          setState(() {
            _selectedPlanetType = value;
            LocalCache.currentSession['planetType'] = value;
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
}
