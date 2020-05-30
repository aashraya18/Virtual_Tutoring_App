import 'package:flutter/material.dart';

import '../../../../common_widgets/customBackButton.dart';
import '../../../../models/advisor_model.dart';

class AdvisorImageWithRating extends StatelessWidget {
  const AdvisorImageWithRating(this.advisor);

  final Advisor advisor;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        _buildImage(context),
        Column(
          children: <Widget>[
            _buildName(),
            _buildRating(),
          ],
        ),
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
    return Image.network(
      advisor.photoUrl,
      height: constraints.height * 0.5,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }

  Widget _buildName() {
    return Text(
      advisor.displayName,
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRating() {
    return Icon(
      Icons.star,
      color: Colors.white,
      size: 40,
    );
  }
}
