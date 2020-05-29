import 'package:flutter/material.dart';

import '../../../../models/student_model.dart';

class MenteeCard extends StatelessWidget {
  const MenteeCard(this.mentee);

  final Student mentee;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/vorbyapp.appspot.com/o/helpers%2F94.jpg?alt=media&token=2dbcb5af-04dd-4ab9-80f6-29f1507b01ca'),
      ),
      title: Text(mentee.displayName),
      trailing: Text('2 hours ago'),
    );
  }
}
