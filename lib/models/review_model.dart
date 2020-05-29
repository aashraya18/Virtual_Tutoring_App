import 'package:flutter/material.dart';

class Review {
  final String heading;
  final String review;
  final String stars;

  Review({
    @required this.heading,
    @required this.review,
    @required this.stars,
  });

  @override
  String toString() {
    return 'heading: $heading, review: $review, stars: $stars';
  }
}
