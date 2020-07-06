import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/advisor_database_provider.dart';

import '../../../models/mentee_model.dart';
//import 'mentee_card.dart';

class AdvisorMenteesScreen extends StatelessWidget {
  static const routeName = '/advisor-mentees';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBar(context),
          _buildSliverList(context),
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

  Widget _buildSliverList(BuildContext context) {
    return StreamBuilder<List<Mentee>>(
        stream: Provider.of<AdvisorDatabaseProvider>(context).getMyMentees(),
        builder: (context, snapshot) {
//          final mentees = snapshot.data;
//          if (snapshot.hasData) {
//            return SliverList(
//              delegate: SliverChildBuilderDelegate(
//                (ctx, index) => MenteeCard(mentees[index]),
//                childCount: mentees.length,
//              ),
//            );
//          } else {
//            return SliverFillRemaining(
//                child: Center(
//                    child: CircularProgressIndicator(
//                        backgroundColor: Theme.of(context).primaryColor)));
//          }
        });
  }
}
