import 'package:android/models/mentee_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/advisor_database_provider.dart';

import 'advisor_chat_screen.dart';

class MenteeCard extends StatelessWidget {
  final Mentee mentee;

  const MenteeCard(this.mentee);

  Future<void> _onTap(BuildContext context) async {
    final student =
        await Provider.of<AdvisorDatabaseProvider>(context, listen: false)
            .getStudent(mentee.uid);
    Navigator.of(context)
        .pushNamed(AdvisorChatScreen.routeName, arguments: student);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Image.asset(
            'assets/images/mentee_icon.png',
            scale: 1.5,
        ),
      ),
      title: Text(mentee.displayName),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Text(
          status(mentee.status),
          style: TextStyle(
              color: statusColor(mentee.status),
          fontSize: 18.0),
        ),
      ),
      onTap: () async => _onTap(context),
    );
  }

  String status(String input) {
    if (input == 'done') return 'Done';
    if (input == 'approved') return 'Approved';
    return 'Approval Pending';
  }

  Color statusColor(String input) {
    if (input == 'done') return Colors.green;
    if (input == 'approved') return Colors.black;
    return Colors.black;
  }
}
