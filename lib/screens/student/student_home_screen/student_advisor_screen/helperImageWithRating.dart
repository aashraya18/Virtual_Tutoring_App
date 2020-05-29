import 'package:flutter/material.dart';

import '../../../../common_widgets/customBackButton.dart';
import '../../../../models/advisor_model.dart';

class HelperImageWithRating extends StatelessWidget {
  const HelperImageWithRating(this.helper);

  final Advisor helper;
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
      helper.photoUrl,
      height: constraints.height * 0.5,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }

  Widget _buildName() {
    return Text(
      helper.displayName,
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
