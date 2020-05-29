import 'package:flutter/material.dart';
import './review_card.dart';

class AdvisorReviewsScreen extends StatelessWidget {
  static const routeName = '/advisor-reviews';
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
          'Feedback',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        centerTitle: true,
        background: Image.asset('assets/images/reviews.png'),
      ),
    );
  }

  Widget _buildSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, index) => ReviewCard(
          title: 'Hello',
          status: 'Stars',
        ),
        childCount: 15,
      ),
    );
  }
}
