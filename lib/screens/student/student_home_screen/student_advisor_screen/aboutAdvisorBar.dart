import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/database_provider.dart';
import '../../../../models/review_model.dart';
import '../../../../models/student_model.dart';

class AboutAdvisorbar extends StatelessWidget {
  const AboutAdvisorbar(this.advisorId);

  final String advisorId;

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Container(
      height: constraints.height * 0.1,
      width: constraints.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(' '),
              Text('About'),
            ],
          ),
          _buildReviewsColumn(context),
          _buildMenteesColumn(context),
        ],
      ),
    );
  }

  Widget _buildReviewsColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<List<Review>>(
            stream: Provider.of<DatabaseProvider>(context)
                .getHelperReviews(advisorId),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(snapshot.data.length.toString());
              return CircularProgressIndicator();
            }),
        Text('Reviews'),
      ],
    );
  }

  Widget _buildMenteesColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<List<Student>>(
            stream: Provider.of<DatabaseProvider>(context)
                .getHelperMentees(advisorId),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(snapshot.data.length.toString());
              return CircularProgressIndicator();
            }),
        Text('Mentees'),
      ],
    );
  }
}
