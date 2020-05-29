import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String title;
  final String status;

  const ReviewCard({
    @required this.title,
    @required this.status,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('assets/images/mentee_icon.png'),
      title: Text(title),
      trailing: Text(status),
    );
  }
}
