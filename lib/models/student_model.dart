import 'package:flutter/material.dart';

class Student {
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;

  Student({
    @required this.uid,
    @required this.displayName,
    @required this.photoUrl,
    @required this.email,
  });

  @override
  String toString() {
    return 'uid: $uid, displayName: $displayName, photoUrl: $photoUrl, email: $email';
  }
}
