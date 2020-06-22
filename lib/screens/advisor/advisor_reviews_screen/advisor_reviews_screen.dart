import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../../../services/services.dart';
import '../../../models/review_model.dart';
import 'review_card.dart';

class AdvisorReviewsScreen extends StatelessWidget {
  static const routeName = '/advisor-reviews';
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
          'Feedback',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        centerTitle: true,
        background: Image.asset('assets/images/reviews.png'),
      ),
    );
  }

  Widget _buildSliverList(BuildContext context) {
    final advisorEmail =
        Provider.of<AuthProvider>(context, listen: false).advisor.email;
    return StreamBuilder<List<Review>>(
        stream: Provider.of<DatabaseProvider>(context)
            .getAdvisorReviews(advisorEmail),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reviews = snapshot.data;
            if (reviews.isNotEmpty) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, index) => ReviewCard(reviews[index]),
                  childCount: reviews.length,
                ),
              );
            } else {
              return SliverFillRemaining(
                  child: Center(child: Text('No Reviews Yet')));
            }
          } else {
            return SliverFillRemaining(
                child: Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor)));
          }
        });
  }
}
