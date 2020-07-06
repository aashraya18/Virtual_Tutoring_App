import 'package:flutter/material.dart';

class Review {
  final String heading;
  final String review;
  final dynamic stars;

  Review({
    @required this.heading,
    @required this.review,
    @required this.stars,
  });
}
