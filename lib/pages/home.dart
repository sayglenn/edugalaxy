// import 'package:edugalaxy/pages/session.dart';
// import 'package:flutter/material.dart';
// import 'package:edugalaxy/pages/navbar.dart';
// import 'package:edugalaxy/local_cache.dart';
// import 'dart:math';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   int? _selectedPlanetType;
//   Future<List<Map<String, dynamic>>>? planets;
//   late AnimationController _controller;
//   late Animation<double> _planetAnimation;

//   final int numberOfPlanets = 8;
//   final int gridRows = 3;
//   final int gridColumns = 3;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//     _fetchPlanets();
//     _planetAnimation =
//         Tween<double>(begin: 0, end: -5).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//   }

  

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   List<Map<String, dynamic>> getRandomPlanets(List<Map<String, dynamic>> originalList, int n) {
//     if (n <= 0 || n > originalList.length) {
//       return originalList;
//     }
//     // Fixed first item
//     Map<String, dynamic> fixedFirstItem = originalList[0];

//     // Create a sublist excluding the first item
//     List<Map<String, dynamic>> tempList = originalList.sublist(1);

//     // Shuffle the sublist to randomize the order of items
//     tempList.shuffle();

//     // Take (n-1) items from the shuffled list
//     List<Map<String, dynamic>> randomItems = tempList.getRange(0, n - 1).toList();

//     // Insert the fixed first item at the beginning
//     randomItems.insert(0, fixedFirstItem);

//     return randomItems;
//   }

//   void _fetchPlanets() {
//     // Fetch planets for the current user
//     setState(() {
//       planets = Future.value(getRandomPlanets(LocalCache.fetchedPlanets, numberOfPlanets) ?? []);
//     });
//   }

//   List<Offset> getRandomGridPositions(Size gridSize) {
//     final random = Random();
//     final positions = <Offset>[];

//     for (int row = 0; row < gridRows; row++) {
//       for (int col = 0; col < gridColumns; col++) {
//         if (row == 1 && col == 1) continue;
//         final x = col * gridSize.width + random.nextDouble() * (gridSize.width - 50) + 25;
//         final y = row * gridSize.height + random.nextDouble() * (gridSize.height - 50) + 25;
//         positions.add(Offset(x, y));
//       }
//     }

//     positions.shuffle();
//     return positions;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final gridSize = Size(screenSize.width / gridColumns, screenSize.height / gridRows);
//     final randomPositions = getRandomGridPositions(gridSize);

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('lib/assets/galaxy_background.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Expanded(
//                 child: FutureBuilder<List<Map<String, dynamic>>>(
//                   future: planets,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error loading planets'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(child: Text('No planets available'));
//                     } else {
//                       List<Map<String, dynamic>> planets = snapshot.data!;
//                       return Stack(
//                         children: planets.map((planet) {
//                           int index = planets.indexOf(planet);
//                           if (index == 0) {
//                             double size = screenSize.width / 3;
//                             String img = (planet['destroyed'])
//                                 ? 'lib/assets/destroyed.jpg'
//                                 : 'lib/assets/${planetNames[planet['planetType']]}/created.jpg';

//                             return Align(
//                               alignment: Alignment.center,
//                               child: AnimatedBuilder(
//                                 animation: _planetAnimation!,
//                                 builder: (context, child) {
//                                   return Transform.translate(
//                                     offset: Offset(0, _planetAnimation.value),
//                                     child: child,
//                                   );
//                                 },
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(size / 2),
//                                   child: Image.asset(
//                                     img,
//                                     width: size,
//                                     height: size,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           } else {
//                             double size = 50;
//                             final position = randomPositions[index];
//                             String img = (planet['destroyed'])
//                                 ? 'lib/assets/destroyed.jpg'
//                                 : 'lib/assets/${planetNames[planet['planetType']]}/created.jpg';

//                             return Positioned(
//                               top: position.dy,
//                               left: position.dx,
//                               child: AnimatedBuilder(
//                                 animation: _planetAnimation!,
//                                 builder: (context, child) {
//                                   return Transform.translate(
//                                     offset: Offset(0, _planetAnimation.value),
//                                     child: child,
//                                   );
//                                 },
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(size / 2),
//                                   child: Image.asset(
//                                     img,
//                                     width: size,
//                                     height: size,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//                         }).toList(),
//                       );
//                     }
//                   },
//                 ),
//               ),
//               OverflowBar(
//                 alignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       backgroundColor: Color.fromARGB(255, 224, 244, 255),
//                     ),
//                     onPressed: () {
//                       LocalCache.autoClick = true;
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => NavBar(),
//                         ),
//                       );
//                     },
//                     child: Text('Create Task'),
//                   ),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       backgroundColor: Color.fromARGB(255, 205, 255, 206),
//                     ),
//                     onPressed: () {
//                       showModalBottomSheet<void>(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return SingleChildScrollView(
//                             child: Container(
//                               padding: EdgeInsets.all(20.0),
//                               child: Form(
//                                 key: _formKey,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Center(
//                                       child: Text(
//                                         "Create a new session",
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     _planetType(),
//                                     Padding(
//                                       padding: EdgeInsets.only(left: 24.0),
//                                       child: Text(
//                                         "Hours:",
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ),
//                                     SessionCreator(formKey: _formKey),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ).whenComplete(() => {}); // Refresh planets after closing the modal
//                     },
//                     child: Text('Create Session'),
//                   ),
//                 ],
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
//           // setState(() {
//           //   _selectedPlanetType = value;
//           // });
//         },
//         onSaved: (value) {
//           setState(() {
//             _selectedPlanetType = value;
//           });
//           LocalCache.currentSession['planetType'] = value;
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

// class SessionCreator extends StatefulWidget {
//   final GlobalKey<FormState> formKey;

//   const SessionCreator({super.key, required this.formKey});

//   @override
//   State<SessionCreator> createState() => SessionCreatorState();
// }

// class SessionCreatorState extends State<SessionCreator> {
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
//             if (widget.formKey.currentState!.validate()) {
//               widget.formKey.currentState!.save();
//               Navigator.pushReplacement(
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

import 'package:edugalaxy/pages/session.dart';
import 'package:flutter/material.dart';
import 'package:edugalaxy/pages/navbar.dart';
import 'package:edugalaxy/local_cache.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedPlanetType;
  Future<List<Map<String, dynamic>>>? planets;
  late AnimationController _controller;
  late Animation<double> _planetAnimation;

  final int numberOfPlanets = 8;
  final int gridRows = 3;
  final int gridColumns = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _fetchPlanets();
    _planetAnimation =
        Tween<double>(begin: 0, end: -5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getRandomPlanets(List<Map<String, dynamic>> originalList, int n) {
    if (n <= 0 || n > originalList.length) {
      return originalList;
    }
    // Fixed first item
    Map<String, dynamic> fixedFirstItem = originalList[0];

    // Create a sublist excluding the first item
    List<Map<String, dynamic>> tempList = originalList.sublist(1);

    // Shuffle the sublist to randomize the order of items
    tempList.shuffle();

    // Take (n-1) items from the shuffled list
    List<Map<String, dynamic>> randomItems = tempList.getRange(0, n - 1).toList();

    // Insert the fixed first item at the beginning
    randomItems.insert(0, fixedFirstItem);

    return randomItems;
  }

  void _fetchPlanets() {
    // Fetch planets for the current user
    setState(() {
      planets = Future.value(getRandomPlanets(LocalCache.fetchedPlanets, numberOfPlanets) ?? []);
    });
  }

  List<Offset> getRandomGridPositions(Size gridSize) {
    final random = Random();
    final positions = <Offset>[];

    for (int row = 0; row < gridRows; row++) {
      for (int col = 0; col < gridColumns; col++) {
        if (row == 1 && col == 1) continue;
        final x = col * gridSize.width + random.nextDouble() * (gridSize.width - 50) + 25;
        final y = row * gridSize.height + random.nextDouble() * (gridSize.height - 50) + 25;
        positions.add(Offset(x, y));
      }
    }

    positions.shuffle();
    return positions;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final gridSize = Size(screenSize.width / gridColumns, screenSize.height / gridRows);
    final randomPositions = getRandomGridPositions(gridSize);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/galaxy_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: planets,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading planets'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No planets available'));
                    } else {
                      List<Map<String, dynamic>> planets = snapshot.data!;
                      return Stack(
                        children: [
                          // First, add the smaller planets to the Stack
                          ...planets.skip(1).toList().asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> planet = entry.value;
                            double size = 50;
                            final position = randomPositions[index];
                            String img = (planet['destroyed'])
                                ? 'lib/assets/destroyed.jpg'
                                : 'lib/assets/${planetNames[planet['planetType']]}/created.jpg';

                            return Positioned(
                              top: position.dy,
                              left: position.dx,
                              child: AnimatedBuilder(
                                animation: _planetAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _planetAnimation.value),
                                    child: child,
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(size / 2),
                                  child: Image.asset(
                                    img,
                                    width: size,
                                    height: size,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          // Then, add the central larger planet
                          Align(
                            alignment: Alignment.center,
                            child: AnimatedBuilder(
                              animation: _planetAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _planetAnimation.value),
                                  child: child,
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(screenSize.width / 6),
                                child: Image.asset(
                                  (planets.first['destroyed'])
                                      ? 'lib/assets/destroyed.jpg'
                                      : 'lib/assets/${planetNames[planets.first['planetType']]}/created.jpg',
                                  width: screenSize.width / 3,
                                  height: screenSize.width / 3,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              OverflowBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 224, 244, 255),
                    ),
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
                      ).whenComplete(() => {}); // Refresh planets after closing the modal
                    },
                    child: Text('Create Session'),
                  ),
                ],
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
          // setState(() {
          //   _selectedPlanetType = value;
          // });
        },
        onSaved: (value) {
          setState(() {
            _selectedPlanetType = value;
          });
          LocalCache.currentSession['planetType'] = value;
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
              Navigator.pushReplacement(
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