import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/database_provider.dart';
import '../../../../models/advisor_model.dart';
import '../../../../models/review_model.dart';
import '../../../../models/student_model.dart';
import './review_card.dart';
import './mentee_card.dart';

enum CurrentTab {
  about,
  reviews,
  mentees,
}

class HelperTabBar extends StatefulWidget {
  const HelperTabBar(this.helper);

  final Advisor helper;

  @override
  _HelperTabBarState createState() => _HelperTabBarState();
}

class _HelperTabBarState extends State<HelperTabBar> {
  CurrentTab _currentTab = CurrentTab.about;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildAboutColumn(context),
            _buildReviewsColumn(context),
            _buildMenteesColumn(context),
          ],
        ),
        _buildTabBottomColor(),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey[400],
        ),
        Expanded(child: _buildBody(context)),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
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
          Text(
            widget.helper.about,
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return StreamBuilder<List<Review>>(
        stream: Provider.of<DatabaseProvider>(context)
            .getHelperReviews(widget.helper.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reviews = snapshot.data;
            return ListView.builder(
              itemBuilder: (ctx, index) => ReviewCard(reviews[index]),
              itemCount: reviews.length,
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget _buildMentees() {
    return StreamBuilder<List<Student>>(
        stream: Provider.of<DatabaseProvider>(context)
            .getHelperMentees(widget.helper.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final mentees = snapshot.data;
            return ListView.builder(
              itemBuilder: (ctx, index) => MenteeCard(mentees[index]),
              itemCount: mentees.length,
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget _buildAboutColumn(BuildContext context) {
    return _buildTab(
      context: context,
      tabTitle: 'About',
      child: Text(''),
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

  Widget _buildReviewsColumn(BuildContext context) {
    return _buildTab(
      context: context,
      tabTitle: 'Reviews',
      child: StreamBuilder<List<Review>>(
          stream: Provider.of<DatabaseProvider>(context)
              .getHelperReviews(widget.helper.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) return Text(snapshot.data.length.toString());
            return CircularProgressIndicator();
          }),
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

  Widget _buildMenteesColumn(BuildContext context) {
    return _buildTab(
      context: context,
      tabTitle: 'Mentees',
      child: StreamBuilder<List<Student>>(
          stream: Provider.of<DatabaseProvider>(context)
              .getHelperMentees(widget.helper.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) return Text(snapshot.data.length.toString());
            return CircularProgressIndicator();
          }),
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
    @required Widget child,
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
            child,
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
