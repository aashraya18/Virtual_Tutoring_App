import 'package:flutter/material.dart';

import '../student_home_screen/student_home_screen.dart';
import '../student_messages_screen/student_messages_screen.dart';
import '../student_settings_screen/student_settings_screen.dart';
import '../../../services/custom_icons_icons.dart';

class StudentDashboardScreen extends StatefulWidget {
  static const routeName = '/student-dashboard';
  @override
  _StudentDashboardScreenState createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _currentTabIndex = 0;

  final _screens = <Widget>[
    StudentHomeScreen(),
    StudentMessagesScreen(),
    StudentSettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentTabIndex],
      bottomNavigationBar: _buildBottomTabBar(),
    );
  }

  Widget _buildBottomTabBar() {
    return BottomNavigationBar(
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
            icon: Icon(CustomIcons.home), title: Text('Home')),
        BottomNavigationBarItem(
            icon: Icon(CustomIcons.comment), title: Text('Messages')),
        BottomNavigationBarItem(
            icon: Icon(CustomIcons.wrench), title: Text('Setings')),
      ],
      onTap: (index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
  }
}
