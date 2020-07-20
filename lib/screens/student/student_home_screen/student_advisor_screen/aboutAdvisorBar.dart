import 'package:android/models/advisor_model.dart';
import 'package:android/screens/student/student_home_screen/student_advisor_detail_screen/student_advisor_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AboutAdvisorBar extends StatelessWidget {
  const AboutAdvisorBar(this.advisorReviewsCount, this.advisorMenteesCount);

  final String advisorReviewsCount;
  final String advisorMenteesCount;
  @override
  Widget build(BuildContext context) {
    final Advisor advisor =
        ModalRoute.of(context).settings.arguments as Advisor;
    final constraints = MediaQuery.of(context).size;
    return Container(
      height: constraints.height * 0.1,
      width: constraints.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StudentAdvisorDetailScreen(
                  advisor: advisor,
                      tabNumber: 1,
                    ))),
            child: Container(
              height: constraints.height * 0.1,
              width: constraints.width / 3,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(' '),
                  Text('About'),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StudentAdvisorDetailScreen(
                  advisor: advisor,
                      tabNumber: 2,
                    ))),
            child: Container(
              height: constraints.height * 0.1,
              width: constraints.width / 3,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(advisorReviewsCount),
                  Text('Reviews'),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StudentAdvisorDetailScreen(
                  advisor: advisor,
                      tabNumber: 3,
                    ))),
            child: Container(
              height: constraints.height * 0.1,
              width: constraints.width / 3,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(MdiIcons.forum),
                  Text('Ask me!'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
