import 'package:android/models/student_model.dart';
import 'package:android/services/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../services/student_database_provider.dart';
import '../../../models/advisor_model.dart';
import './student_chat_screen.dart';

class StudentMessagesTab extends StatefulWidget {
  @override
  _StudentMessagesTabState createState() => _StudentMessagesTabState();
}

class _StudentMessagesTabState extends State<StudentMessagesTab> {
  Student student;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<AuthProvider>(context).student;
    return Scaffold(
      body: StreamBuilder<List<String>>(
        stream:
            Provider.of<StudentDatabaseProvider>(context).getMyMessagesList(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            final advisorEmails = snapshot.data;
            if (advisorEmails.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (ctx, index) => FutureBuilder<Advisor>(
                  future: Provider.of<StudentDatabaseProvider>(context)
                      .getMyMessages(advisorEmails[index]),
                  builder: (ctx, fsnapshot) {
                    if (fsnapshot.hasData) {
                      return _buildTile(context, fsnapshot.data);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                itemCount: advisorEmails.length,
              );
            } else {
              return Center(child: Text('No Chats Yet'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getBookedSlots(advisorEmail) async {
    List<Map<String, dynamic>> slotList = [];
    String path = 'students/${student.uid}/advisors/$advisorEmail/slotBooking';
    await Firestore.instance.collection(path).snapshots().listen((result) {
      result.documents.forEach((result) {
        Map<String, dynamic> slots = {
          "Date": result.documentID,
          "Time": result.data["Booked"],
        };
        print('Slots : $slots');
        slotList.add(slots);
      });
    });
    return slotList;
  }

//void getBookedSlotList(BuildContext context,advisorEmail){
//  StreamBuilder<List<String>>(
//    stream:
//    Provider.of<StudentDatabaseProvider>(context).getMyBookedSlotList(advisorEmail),
//    builder: (ctx, snapshot) {
//      if (snapshot.hasData) {
//        final bookedSlots = snapshot.data;
//        return Text('$bookedSlots');
//      }else {
//        return Center(child: CircularProgressIndicator());
//      }
//    },
//  );
//}

  Widget _buildTile(BuildContext context, Advisor advisor) {
//  getBookedSlotList(context,advisor.email);

    return FutureBuilder(
        future: getBookedSlots(advisor.email),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> slotList) {
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
                trailing: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '30 mins',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Icon(
                        MdiIcons.dotsHorizontal,
                        size: 20.0,
                      ),
                    ],
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
                      SizedBox(
                        height: 10.0,
                      ),
                      slotList.data != null
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: slotList.data.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(

                                      '${slotList.data[index]['Date']}',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    ListView.builder(
//                                    scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: slotList
                                            .data[index]['Time'].length,
                                        itemBuilder: (BuildContext ctx,
                                            int indext) {
                                          return Text(
                                            '${slotList.data[index]['Time'][indext]} GMT',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          );
                                        }),
                                    SizedBox(
                                      height: 5.0,
                                    )
//                                Divider(
//                                  thickness: 1.0,
//                                  height: 1.0,
//                                  endIndent: 10.0,
//                                ),
                                  ],
                                );
                              })
                          : Text(''),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
