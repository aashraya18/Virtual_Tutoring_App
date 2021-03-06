import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../common_widgets/customBackButton.dart';
import '../../../../models/advisor_model.dart';

class AdvisorBlurImageWithDetail extends StatelessWidget {
  const AdvisorBlurImageWithDetail(this.advisor);
  final Advisor advisor;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _buildImage(context),
        _buildDetails(),
        Positioned(
            top: 20,
            left: 10,
            child: CustomBackButton(
              iconColor: Colors.white60,
              iconSize: 33,
            )),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Container(
      height: constraints.height * 0.2,
      width: constraints.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(advisor.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey[700].withOpacity(0.1),
          ),
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      children: <Widget>[
        Text(
          advisor.displayName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${advisor.college} - ${advisor.branch}',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
