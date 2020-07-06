import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../services/student_database_provider.dart';
import '../../../models/advisor_model.dart';
import 'student_chat_screen.dart';

class StudentAdvisorsTab extends StatelessWidget {

  bool _checkTime(List<dynamic> slots,int now){
    int startTime;
    int endTime;
    for(int i=0;i<slots.length;++i){
      String start = '' ;
      for(int j=0;j<slots[i].length;++j){
        if(slots[i][j] != "-" && slots[i][j] != ".")
          start = start + slots[i][j];
        else if(slots[i][j] == "-") {
          startTime = int.parse(start);
          break;
        }
      }
      String end = '';
      for(int j=6;j<slots[i].length;++j){
        if(slots[i][j] != '.')
          end = end+slots[i][j];
      }
      endTime = int.parse(end);
    }
    if(now>=startTime && now<=endTime)
      return true;
    else
      return false;
  }

  Future<bool> getSlot(BuildContext context ,String studentEmail, String advisorEmail) async{
    //final student = Provider.of<AuthProvider>(context, listen: false).student.email;
    //final advisor = Provider.of<AuthProvider>(context,listen: false).advisor.email;
    final now = DateTime.now();

    var formatDay = DateFormat('d-M-yyyy');
    var formatTime = DateFormat('HHmm');

    String formattedDay = formatDay.format(now);
    int formattedTime = int.parse(formatTime.format(now));

    final List<dynamic> temp = await Provider.of<StudentDatabaseProvider>(context).getSlotTiming('$studentEmail', '$advisorEmail','26-6-2020');

    if(temp == null){
      print('Not today');
      return false;
    }
    else
    if(_checkTime(temp, 1750)){
      print('Go to the call');
      return true;
    }
    else
      print('Not now');
    return false;
  }
  @override
  Widget build(BuildContext context) {
    //getSlot(context, 'test@test.com', 'ashish@advisor.com');
    return Scaffold(
      body: StreamBuilder<List<String>>(
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
              return Center(child: Text('No Advisors Yet'));
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
          onTap: () => Navigator.of(context)
              .pushNamed(StudentChatScreen.routeName, arguments: advisor),
          leading: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(advisor.photoUrl)),
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
