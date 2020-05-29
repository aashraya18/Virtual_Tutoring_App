import 'package:flutter/material.dart';

import './student_colleges_screen/student_colleges_screen.dart';
import './student_competitive_screen/student_competitve_screen.dart';
import './student_expertise_screen/student_expertise_screen.dart';

enum SelectedScreen {
  colleges,
  competitive,
  expertise,
}

class StudentHomeScreen extends StatefulWidget {
  static const routeName = '/student-home';
  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  SelectedScreen _mode = SelectedScreen.competitive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildCustomTabBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: statusBarHeight * 1.5, horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: <Widget>[
              _buildCollegesTab(),
              _buildCompetitiveExamsTab(),
              _buildExpertiseTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_mode == SelectedScreen.colleges) return StudentCollegesScreen();
    if (_mode == SelectedScreen.expertise) return StudentExpertiseScreen();
    return StudentCompetitiveScreen();
  }

  Widget _buildCollegesTab() {
    return Expanded(
      child: _buildTab(
        tabName: 'Colleges',
        textColor:
            _mode == SelectedScreen.colleges ? Colors.white : Colors.black,
        backColor: _mode == SelectedScreen.colleges
            ? Theme.of(context).primaryColor
            : Colors.white,
        onPressed: _mode == SelectedScreen.colleges
            ? null
            : () {
                setState(() {
                  _mode = SelectedScreen.colleges;
                });
              },
      ),
    );
  }

  Widget _buildCompetitiveExamsTab() {
    return _buildTab(
      tabName: 'Competitive Exams',
      textColor:
          _mode == SelectedScreen.competitive ? Colors.white : Colors.black,
      backColor: _mode == SelectedScreen.competitive
          ? Theme.of(context).primaryColor
          : Colors.white,
      onPressed: _mode == SelectedScreen.competitive
          ? null
          : () {
              setState(() {
                _mode = SelectedScreen.competitive;
              });
            },
    );
  }

  Widget _buildExpertiseTab() {
    return Expanded(
      child: _buildTab(
        tabName: 'Expertise',
        textColor:
            _mode == SelectedScreen.expertise ? Colors.white : Colors.black,
        backColor: _mode == SelectedScreen.expertise
            ? Theme.of(context).primaryColor
            : Colors.white,
        onPressed: _mode == SelectedScreen.expertise
            ? null
            : () {
                setState(() {
                  _mode = SelectedScreen.expertise;
                });
              },
      ),
    );
  }

  Widget _buildTab(
      {String tabName, Color textColor, Color backColor, Function onPressed}) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            color: backColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              tabName,
              softWrap: false,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
        ),
      ),
      onTap: onPressed,
    );
  }
}
