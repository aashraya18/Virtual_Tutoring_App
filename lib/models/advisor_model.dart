import 'package:flutter/material.dart';

class Advisor {
  final String uid;
  final String displayName;
  final String college;
  final String branch;
  final String about;
  final String email;
  final String phoneNumber;
  final String photoUrl;

  Advisor({
    @required this.uid,
    @required this.displayName,
    @required this.college,
    @required this.branch,
    @required this.about,
    @required this.email,
    @required this.phoneNumber,
    @required this.photoUrl,
  });

  @override
  String toString() {
    return '''
    uid: $uid, 
    displayName: $displayName, 
    college: $college, 
    branch: $branch, 
    email: $email,
    about: $about, 
    phoneNumber: $phoneNumber,
    photoUrl: $photoUrl
    ''';
  }
}
