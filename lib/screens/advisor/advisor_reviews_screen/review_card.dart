import 'package:flutter/material.dart';
import '../../../models/review_model.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard(this.review);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('assets/images/mentee_icon.png'),
      title: Text(review.heading),
      trailing: Text(review.stars),
    );
  }
}
