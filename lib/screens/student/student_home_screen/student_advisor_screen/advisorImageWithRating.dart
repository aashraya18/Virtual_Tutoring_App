import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../../common_widgets/customBackButton.dart';
import '../../../../models/advisor_model.dart';

class AdvisorImageWithRating extends StatefulWidget {
  const AdvisorImageWithRating(this.advisor);

  final Advisor advisor;

  @override
  _AdvisorImageWithRatingState createState() => _AdvisorImageWithRatingState();
}

class _AdvisorImageWithRatingState extends State<AdvisorImageWithRating> {
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
      widget.advisor.photoUrl,
      height: constraints.height * 0.5,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }

  Widget _buildName() {
    return Text(
      widget.advisor.displayName,
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRating() {
    return SmoothStarRating(
        allowHalfRating: true,
        onRated: (v) {},
        starCount: 5,
        rating: double.parse(widget.advisor.rating.toString()),
        size: 40.0,
        isReadOnly: true,
        filledIconData: Icons.star,
        halfFilledIconData: Icons.star_half,
        color: Colors.white,
        borderColor: Colors.white,
        spacing: 0.0);
  }
}
