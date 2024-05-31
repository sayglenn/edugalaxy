import 'package:edugalaxy/pages/home.dart';
import 'package:edugalaxy/pages/settings.dart';
import 'package:edugalaxy/pages/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 250, 190),
        title: Text(currentPageIndex == 0
            ? 'Home'
            : currentPageIndex == 1
                ? 'Tasks'
                : 'Settings'),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) => {
          setState(() {
            currentPageIndex = index;
          })
        },
      ),
      body: <Widget>[
        const HomePage(),
        const TasksPage(),
        const SettingsPage(),
      ][currentPageIndex],
    );
  }
}
