import 'package:flutter/material.dart';

class Advisor {
  final String about;
  final String branch;
  final String college;
  final String displayName;
  final String email;
  final String menteesCount;
  final String phoneNumber;
  final String photoUrl;
  final String reviewsCount;
  final String uid;

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
    @required this.uid,
  });

  @override
  String toString() {
    return '''
    about: $about, 
    branch: $branch, 
    college: $college, 
    displayName: $displayName, 
    email: $email,
    menteesCount: $menteesCount,
    phoneNumber: $phoneNumber,
    photoUrl: $photoUrl,
    reviewsCount: $reviewsCount,
    uid: $uid, 
    ''';
  }
}
