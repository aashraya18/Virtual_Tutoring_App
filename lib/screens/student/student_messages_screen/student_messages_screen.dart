import 'package:flutter/material.dart';

class StudentMessagesScreen extends StatelessWidget {
  static const routeName = '/student-messages';
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
            Center(
                child: Text(
              'It\'s lonely out here.\nGet some guidance now!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18),
            )),
            Center(child: Icon(Icons.forum)),
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
