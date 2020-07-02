import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/advisor_database_provider.dart';
import '../../../models/student_model.dart';
import './advisor_chat_screen.dart';

class AdvisorMenteeDetailScreen extends StatelessWidget {
  static const routeName = '/mentee-detail';
  @override
  Widget build(BuildContext context) {
    final menteeUid = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Student>(
        future:
            Provider.of<AdvisorDatabaseProvider>(context).getStudent(menteeUid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final student = snapshot.data;
            return Column(
              children: <Widget>[
                Container(
                  height: 250,
                  alignment: Alignment.center,
                  child: Image.network(student.photoUrl),
                ),
                Divider(),
                Container(
                  child: ListTile(
                    leading: Image.asset('assets/images/mentee_icon.png'),
                    title: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            AdvisorChatScreen.routeName,
                            arguments: student);
                      },
                      child: Text(
                        student.displayName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  child: Text('Slots'),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
