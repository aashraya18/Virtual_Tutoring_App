import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../services/student_database_provider.dart';
import '../../../models/advisor_model.dart';
import 'student_chat_screen.dart';

class StudentAdvisorsTab extends StatelessWidget {


  bool deactivate = true;

  @override
  Widget build(BuildContext context) {
    //getSlot(context, 'test@test.com', 'ashish@advisor.com');
    return Scaffold(
      body: deactivate ? Center(child: Text('Coming Soon...',
      style: TextStyle(
        color: Color(0xff42858C),
        fontSize: 25.0,
        fontWeight: FontWeight.w500
      ),)) :StreamBuilder<List<String>>(
        stream:
            Provider.of<StudentDatabaseProvider>(context).getMyAdvisorsList(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            final advisorUids = snapshot.data;
            if (advisorUids.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (ctx, index) => FutureBuilder<Advisor>(
                  future: Provider.of<StudentDatabaseProvider>(context)
                      .getMyAdvisor(advisorUids[index]),
                  builder: (ctx, fsnapshot) {
                    if (fsnapshot.hasData) {
                      return _buildTile(context, fsnapshot.data);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                itemCount: advisorUids.length,
              );
            } else {
              return Center(child: Text('It\'s lonely out here.\nGet some guidance now!',
              style: TextStyle(
                color: Color(0xff42858C),
                fontSize: 20.0,
              ),));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildTile(BuildContext context, Advisor advisor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListTile(
//          onTap: () => Navigator.of(context)
//              .pushNamed(StudentChatScreen.routeName, arguments: advisor),
          leading: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(advisor.photoUrl),
              ),
           ),
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  advisor.displayName,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(advisor.college),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
