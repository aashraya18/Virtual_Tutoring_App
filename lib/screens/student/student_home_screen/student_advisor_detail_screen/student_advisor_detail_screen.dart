import 'package:flutter/material.dart';

import '../../../../models/advisor_model.dart';
import '../../../../common_widgets/bottomFlatButton.dart';
import '../../../../services/custom_icons_icons.dart';
import '../student_time_screen/student_time_screen.dart';
import 'advisorBlurImageWithDetail.dart';
import 'advisorTabBar.dart';

class StudentAdvisorDetailScreen extends StatefulWidget {
  static const routeName = '/student-advior-detail';
  final int tabNumber;
  final Advisor advisor;
  const StudentAdvisorDetailScreen({Key key, this.tabNumber , this.advisor}) : super(key: key);


  @override
  _StudentAdvisorDetailScreenState createState() => _StudentAdvisorDetailScreenState();
}

class _StudentAdvisorDetailScreenState extends State<StudentAdvisorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    final Advisor advisor = widget.advisor;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              AdvisorBlurImageWithDetail(advisor),
              Expanded(child: AdvisorTabBar(advisor,widget.tabNumber)),
              BottomFlatButton(
                iconData: CustomIcons.user_add_outline,
                label: 'Guide Me',
                iconColor: Colors.white,
                textColor: Colors.white,
                iconSize: 20,
                textSize: 18,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => StudentTimeScreen(advisor: advisor)));
                },
              )
            ],
          ),
          _buildSmallImageOnTop(constraints, advisor.photoUrl),
        ],
      ),
    );
  }

  Widget _buildSmallImageOnTop(Size constraints, String photoUrl) {
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
            photoUrl,
            height: constraints.height * 0.09,
            width: constraints.height * 0.09,
          ),
        ),
      ),
    );
  }
}
