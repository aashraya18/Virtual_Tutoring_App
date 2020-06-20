import 'package:flutter/material.dart';

import '../../../../models/mentee_model.dart';

class MenteeCard extends StatelessWidget {
  const MenteeCard(this.mentee);

  final Mentee mentee;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/vorbyapp.appspot.com/o/empty_user.jpg?alt=media&token=b3c39bcf-2baa-444a-b739-c85aba5cc220'),
      ),
      title: Text(mentee.displayName),
    );
  }
}
