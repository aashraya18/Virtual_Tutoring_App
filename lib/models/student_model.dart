import 'package:flutter/material.dart';

class Student {
  final String bio;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  final String uid;


  Student({
    @required this.bio,
    @required this.displayName,
    @required this.email,
    @required this.phoneNumber,
    @required this.photoUrl,
    @required this.uid,

  });
}
