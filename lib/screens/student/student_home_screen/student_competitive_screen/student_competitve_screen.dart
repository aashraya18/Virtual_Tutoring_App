import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android/screens/student/student_guides_screen/student_guides_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../services/student_database_provider.dart';
import '../widgets/advisorListViewBuilder.dart';

class StudentCompetitiveScreen extends StatefulWidget {
  static const routeName = '/student-competitive';

  @override
  _StudentCompetitiveScreenState createState() => _StudentCompetitiveScreenState();
}

class _StudentCompetitiveScreenState extends State<StudentCompetitiveScreen> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  _getToken(){
    _fcm.getToken().then((token){
      print("TOKEN:$token");
    });
  }

  _configFirebaseListeners(){
    _fcm.configure(
        onMessage: (Map<String,dynamic>message)async{
          print('onMessage:$message');
          Navigator.popAndPushNamed(context, StudentGuidesScreen.routeName);
        },
        onLaunch: (Map<String,dynamic>message)async{
          print('onLaunch:$message');
          Navigator.popAndPushNamed(context, StudentGuidesScreen.routeName);
        },
        onResume: (Map<String,dynamic>message)async{
          print('onResume:$message');
          Navigator.popAndPushNamed(context, StudentGuidesScreen.routeName);
        }
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
    _configFirebaseListeners();

  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        AdvisorListViewBuilder(
          title: 'JEE - Advance',
          stream: Provider.of<StudentDatabaseProvider>(context)
              .getFilteredAdvisors('jee-advanced'),
        ),
        AdvisorListViewBuilder(
          title: 'JEE - Main',
          stream: Provider.of<StudentDatabaseProvider>(context)
              .getFilteredAdvisors('jee-mains'),
        ),
        AdvisorListViewBuilder(
          title: 'VITEE',
          stream: Provider.of<StudentDatabaseProvider>(context)
              .getFilteredAdvisors('VITEE'),
        ),
      ],
    );
  }
}
