import 'package:flutter/material.dart';

import './advisor_mentee_detail_screen.dart';

class MenteeCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;

  const MenteeCard({
    @required this.title,
    @required this.status,
    @required this.statusColor,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('assets/images/mentee_icon.png'),
      title: Text(title),
      trailing: Text(
        status,
        style: TextStyle(color: statusColor),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(AdvisorMenteeDetailScreen.routeName);
      },
    );
  }
}
