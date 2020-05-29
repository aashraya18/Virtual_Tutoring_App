import 'package:flutter/material.dart';

import '../../../../models/review_model.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard(this.review);

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${review.stars} Stars'),
              Text(
                '3 Hours ago',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            review.heading,
            style: TextStyle(fontSize: 19),
          ),
          SizedBox(height: 5),
          Text(
            review.review,
            style: TextStyle(fontSize: 17),
          ),
          Divider(),
        ],
      ),
    );
  }
}
