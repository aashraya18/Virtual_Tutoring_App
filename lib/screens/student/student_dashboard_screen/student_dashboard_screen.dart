import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import '../student_home_screen/student_home_screen.dart';
import '../student_guides_screen/student_guides_screen.dart';
import '../student_settings_screen/student_settings_screen.dart';
import '../../../services/custom_icons_icons.dart';

class StudentDashboardScreen extends StatefulWidget {
  static const routeName = '/student-dashboard';
  @override
  _StudentDashboardScreenState createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> with AfterLayoutMixin<StudentDashboardScreen>{
  int _currentTabIndex = 0;

  @override
  void afterFirstLayout(BuildContext context) {
    _neverSatisfied();
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
          title: Text(
            'Spin and get a chance to win cash and a call with advisors',
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Play',
                    style: TextStyle(
                        fontSize: 15.0,
                      color: Colors.white,
                    ),),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/referral');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ],
          ),
        );
      },
    );
  }

  final _screens = <Widget>[
    StudentHomeScreen(),
    StudentGuidesScreen(),
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
