import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/student_database_provider.dart';
import '../../../../models/advisor_model.dart';
import '../../../../models/review_model.dart';
import '../../../../models/mentee_model.dart';
import 'review_card.dart';
import 'mentee_card.dart';

enum CurrentTab {
  about,
  reviews,
  mentees,
}

class AdvisorTabBar extends StatefulWidget {
  const AdvisorTabBar(this.advisor);

  final Advisor advisor;

  @override
  _AdvisorTabBarState createState() => _AdvisorTabBarState();
}

class _AdvisorTabBarState extends State<AdvisorTabBar> {
  CurrentTab _currentTab = CurrentTab.about;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildAboutColumn(),
            _buildReviewsColumn(),
            _buildMenteesColumn(),
          ],
        ),
        _buildTabBottomColor(),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey[400],
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_currentTab == CurrentTab.reviews) return _buildReviews();
    if (_currentTab == CurrentTab.mentees) return _buildMentees();
    return _buildAbout();
  }

  Widget _buildAbout() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Sharing my experience with aspiring students',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Text(
              widget.advisor.about,
              style: TextStyle(fontSize: 17),
              softWrap: true,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return StreamBuilder<List<Review>>(
        stream: Provider.of<StudentDatabaseProvider>(context)
            .getAdvisorReviews(widget.advisor.email),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reviews = snapshot.data;
            if (reviews.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (ctx, index) => ReviewCard(reviews[index]),
                itemCount: reviews.length,
              );
            } else {
              return Center(child: Text('No reviews yet.'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildMentees() {
    return StreamBuilder<List<Mentee>>(
        stream: Provider.of<StudentDatabaseProvider>(context)
            .getAdvisorMentees(widget.advisor.email),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final mentees = snapshot.data;
            if (mentees.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (ctx, index) => MenteeCard(mentees[index]),
                itemCount: mentees.length,
              );
            } else {
              return Center(child: Text('No mentees yet.'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildAboutColumn() {
    return _buildTab(
      context: context,
      tabTitle: 'About',
      child: '',
      color: Colors.blue,
      onPressed: _currentTab == CurrentTab.about
          ? null
          : () {
              setState(() {
                _currentTab = CurrentTab.about;
              });
            },
    );
  }

  Widget _buildReviewsColumn() {
    return _buildTab(
      context: context,
      tabTitle: 'Reviews',
      child: widget.advisor.reviewsCount.toString(),
      color: Colors.black,
      onPressed: _currentTab == CurrentTab.reviews
          ? null
          : () {
              setState(() {
                _currentTab = CurrentTab.reviews;
              });
            },
    );
  }

  Widget _buildMenteesColumn() {
    return _buildTab(
      context: context,
      tabTitle: 'Mentees',
      child: widget.advisor.menteesCount.toString(),
      color: Colors.red,
      onPressed: _currentTab == CurrentTab.mentees
          ? null
          : () {
              setState(() {
                _currentTab = CurrentTab.mentees;
              });
            },
    );
  }

  Widget _buildTab({
    @required BuildContext context,
    @required String tabTitle,
    @required String child,
    @required Function onPressed,
    @required Color color,
  }) {
    final constraints = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        height: constraints.height * 0.1,
        width: constraints.width / 3,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(child),
            Text(tabTitle),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  Widget _buildTabBottomColor() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 3,
            color: _currentTab == CurrentTab.about
                ? Colors.teal
                : Colors.transparent,
          ),
        ),
        Expanded(
          child: Container(
            height: 3,
            color: _currentTab == CurrentTab.reviews
                ? Colors.teal
                : Colors.transparent,
          ),
        ),
        Expanded(
          child: Container(
            height: 3,
            color: _currentTab == CurrentTab.mentees
                ? Colors.teal
                : Colors.transparent,
          ),
        ),
      ],
    );
  }
}
