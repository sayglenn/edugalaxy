import 'package:edugalaxy/pages/home.dart';
import 'package:edugalaxy/pages/settings.dart';
import 'package:edugalaxy/pages/tasks.dart';
import 'package:edugalaxy/local_cache.dart';
import 'package:flutter/material.dart';


class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 1;

  @override
  void initState() {
    super.initState();
    currentPageIndex = LocalCache.autoClick ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(190, 15, 15, 112),
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
      body: [
        const HomePage(),
        const TasksPage(),
        const SettingsPage(),
      ][currentPageIndex],
    );
  }
}
