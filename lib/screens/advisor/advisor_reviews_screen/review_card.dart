import 'package:flutter/material.dart';
import '../../../models/review_model.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard(this.review);
  @override
  Widget build(BuildContext context) {
    print(review.heading);
    return ExpansionTile(

      leading: Image.asset('assets/images/mentee_icon.png',height: 25,),
      title: Text(review.heading,style: TextStyle(color: Colors.black),),
      trailing: SmoothStarRating(
        starCount: 5,
        rating: review.stars,
        size: 20.0,
        isReadOnly: true,
        filledIconData: Icons.star,
        halfFilledIconData: Icons.star_half,
        color: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        spacing: 0.0,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(top:8.0,bottom: 20),
          child: Text(review.review),
        ),
      ],
    );
  }
}
