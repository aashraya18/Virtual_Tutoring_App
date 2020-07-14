import 'package:flutter/material.dart';

class Advisor {
  final String about;
  final String branch;
  final String college;
  final String displayName;
  final String email;
  final dynamic menteesCount;
  final String phoneNumber;
  final String photoUrl;
  final dynamic reviewsCount;
  final dynamic rating;
  final String uid;
  final Map payment;

  Advisor({
    @required this.about,
    @required this.branch,
    @required this.college,
    @required this.displayName,
    @required this.email,
    @required this.menteesCount,
    @required this.phoneNumber,
    @required this.photoUrl,
    @required this.reviewsCount,
    @required this.rating,
    @required this.uid,
    @required this.payment,
  });
}
