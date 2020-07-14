import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AboutAdvisorBar extends StatelessWidget {
  const AboutAdvisorBar(this.advisorReviewsCount, this.advisorMenteesCount);

  final String advisorReviewsCount;
  final String advisorMenteesCount;
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(advisorReviewsCount),
              Text('Reviews'),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(MdiIcons.forum),
              Text('Ask me!'),
            ],
          ),
        ],
      ),
    );
  }
}
