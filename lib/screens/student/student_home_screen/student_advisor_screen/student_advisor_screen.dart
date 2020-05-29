import 'package:flutter/material.dart';

import '../../../../models/advisor_model.dart';
import '../../../../common_widgets/bottomFlatButton.dart';
import './helperImageWithRating.dart';
import './helperAboutBar.dart';
import '../student_advisor_detail_screen/student_advisor_detail_screen.dart';
import '../../../../services/custom_icons_icons.dart';

class StudentAdvisorScreen extends StatelessWidget {
  static const routeName = '/student-advisor';
  StudentAdvisorScreen(this.helper);
  final Advisor helper;
  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          HelperImageWithRating(helper),
          Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BottomFlatButton(
                    iconData: CustomIcons.user_add_outline,
                    label: 'Guide Me',
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    iconSize: 20,
                    textSize: 18,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) =>
                              StudentAdvisorDetailScreen(helper)));
                    },
                  ),
                  HelperAboutBar(helper.uid),
                  Divider(),
                ],
              ),
              _buildSmallImageOnTop(constraints),
            ],
          ),
          _buildDescription(constraints.height),
        ],
      ),
    );
  }

  Widget _buildSmallImageOnTop(Size constraints) {
    return Positioned(
      top: constraints.height * 0.03 - 3,
      left: constraints.width / 15 - 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            helper.photoUrl,
            height: constraints.height * 0.09,
            width: constraints.height * 0.09,
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(double height) {
    return Container(
      height: height * 0.3,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.topLeft,
      child: Text(
        helper.about,
        softWrap: true,
        overflow: TextOverflow.clip,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
