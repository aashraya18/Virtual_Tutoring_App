import 'package:flutter/material.dart';

import 'student_messages_tab.dart';

import './student_messages_tab.dart';
import './student_advisors_tab.dart';

class StudentGuidesScreen extends StatelessWidget {
  static const routeName = '/student-guides';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Guides'),
          bottom: _buildTabBar(context),
        ),
        body: TabBarView(
          children: [
            Center(child: StudentAdvisorsTab()),
            Center(child: StudentMessagesTab()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      indicatorColor: Theme.of(context).primaryColor,
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.black54,
      tabs: [
        Tab(child: _buildTitleText('Advisors')),
        Tab(child: _buildTitleText('Messages')),
      ],
    );
  }

  Widget _buildTitleText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
      ),
    );
  }
}
