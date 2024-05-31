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
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/icons/tasks.svg',
            ),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/icons/settings.svg',
            ),
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
        HomePage(),
        TasksPage(),
        SettingsPage(),
      ][currentPageIndex],
    );
  }
}
