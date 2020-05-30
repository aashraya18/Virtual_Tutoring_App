import 'package:flutter/material.dart';

import '../../../../models/advisor_model.dart';
import './../student_advisor_screen/student_advisor_screen.dart';

class AdvisorCard extends StatelessWidget {
  const AdvisorCard(this.advisor);
  final Advisor advisor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 262,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          _buildImageAndName(),
          SizedBox(height: 20),
          _buildCollegeAndBranch(context),
        ],
      ),
    );
  }

  Widget _buildImageAndName() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            advisor.photoUrl,
            height: 160,
            width: 130,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            advisor.displayName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildCollegeAndBranch(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(5),
          width: 130,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(advisor.college, style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
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
      onTap: () {
        Navigator.of(context)
            .pushNamed(StudentAdvisorScreen.routeName, arguments: advisor);
      },
    );
  }
}
