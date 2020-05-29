import 'package:flutter/material.dart';

import '../../../../models/advisor_model.dart';
import '../../../../common_widgets/bottomFlatButton.dart';
import './helperBlurImageWithDetail.dart';
import './helperTabBar.dart';
import '../student_time_screen/student_time_screen.dart';
import '../../../../services/custom_icons_icons.dart';

class StudentAdvisorDetailScreen extends StatelessWidget {
  static const routeName = '/student-advior-detail';
  const StudentAdvisorDetailScreen(this.helper);
  final Advisor helper;

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              HelperBlurImageWithDetail(helper),
              Expanded(child: HelperTabBar(helper)),
              BottomFlatButton(
                iconData: CustomIcons.user_add_outline,
                label: 'Guide Me',
                iconColor: Colors.white,
                textColor: Colors.white,
                iconSize: 20,
                textSize: 18,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => StudentTimeScreen()));
                },
              )
            ],
          ),
          _buildSmallImageOnTop(constraints)
        ],
      ),
    );
  }

  Widget _buildSmallImageOnTop(Size constraints) {
    return Positioned(
      top: constraints.height * 0.15 - 3,
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
}
