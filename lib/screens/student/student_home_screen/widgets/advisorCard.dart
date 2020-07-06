import 'package:flutter/material.dart';

import '../../../../models/advisor_model.dart';
import '../student_advisor_screen/student_advisor_screen.dart';

class AdvisorCard extends StatelessWidget {
  const AdvisorCard(this.advisor);
  final Advisor advisor;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.3,
      padding: EdgeInsets.all(height * 0.01),
      child: Column(
        children: <Widget>[
          _buildImageAndName(context, height, width),
          SizedBox(height: height * 0.02),
          _buildCollegeAndBranch(context, height, width),
        ],
      ),
    );
  }

  Widget _buildImageAndName(BuildContext context, double height, double width) {
    return GestureDetector(
      child: Container(
        height: height * 0.2,
        width: width * 0.3,
        child: FittedBox(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  advisor.photoUrl,
                  height: height * 0.2,
                  width: width * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(height * 0.01),
                child: Text(
                  advisor.displayName,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(StudentAdvisorScreen.routeName, arguments: advisor);
      },
    );
  }

  Widget _buildCollegeAndBranch(
      BuildContext context, double height, double width) {
    return GestureDetector(
      child: Container(
        height: height * 0.06,
        width: width * 0.3,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          child: FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(advisor.college, style: TextStyle(fontSize: 16)),
                SizedBox(height: height * 0.005),
                FittedBox(
                  child: Text(
                    advisor.branch,
                    style: TextStyle(fontSize: 13),
                  ),
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(StudentAdvisorScreen.routeName, arguments: advisor);
      },
    );
  }
}
