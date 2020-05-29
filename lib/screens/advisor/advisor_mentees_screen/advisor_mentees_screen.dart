import 'package:flutter/material.dart';

import './mentee_card.dart';

class AdvisorMenteesScreen extends StatelessWidget {
  static const routeName = '/advisor-mentees';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBar(context),
          _buildSliverList(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).accentColor,
      expandedHeight: 250,
      iconTheme: IconThemeData(color: Colors.black),
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Your Mentees',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        centerTitle: true,
        background: Image.asset('assets/images/mentees.png'),
      ),
    );
  }

  Widget _buildSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, index) => MenteeCard(
          title: 'Hello',
          status: 'Approval Pending',
          statusColor: Colors.green,
        ),
        childCount: 15,
      ),
    );
  }
}
