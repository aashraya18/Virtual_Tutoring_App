import 'package:android/screens/advisor/advisor_ask_me/answer_question_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'profile_tile.dart';
import 'main_tile.dart';

import '../advisor_screens.dart';

class AdvisorDashboardScreen extends StatelessWidget {
  static const routeName = '/advisor-dashboard';
  final FirebaseMessaging _fcm = FirebaseMessaging();
  _configFirebaseListeners(BuildContext context){
    _fcm.configure(
        onMessage: (Map<String,dynamic>message)async{
          print('onMessage:$message');
          Navigator.popAndPushNamed(context, AdvisorMenteesScreen.routeName);
        },
        onLaunch: (Map<String,dynamic>message)async{
          print('onLaunch:$message');
          Navigator.popAndPushNamed(context, AdvisorMenteesScreen.routeName);
        },
        onResume: (Map<String,dynamic>message)async{
          print('onResume:$message');
          Navigator.popAndPushNamed(context, AdvisorMenteesScreen.routeName);
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    _configFirebaseListeners(context);
    final double statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(height: statusHeight),
            ProfileTile(),
            Expanded(
              child: Row(
                children: <Widget>[
                  MainTile(
                    left: 20,
                    top: 40,
                    right: 10,
                    bottom: 25,
                    imageLabel: 'mentees.png',
                    tileLabel: 'Your Mentees',
                    pageRoute: AdvisorMenteesScreen.routeName,
                  ),
                  MainTile(
                    left: 10,
                    top: 40,
                    right: 20,
                    bottom: 25,
                    imageLabel: 'schedule.png',
                    tileLabel: 'Your Schedule',
                    pageRoute: AdvisorScheduleScreen.routeName,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  MainTile(
                    left: 20,
                    top: 25,
                    right: 10,
                    bottom: 40,
                    imageLabel: 'reviews.png',
                    tileLabel: 'Reviews',
                    pageRoute: AdvisorReviewsScreen.routeName,
                  ),
                  MainTile(
                    left: 10,
                    top: 25,
                    right: 20,
                    bottom: 40,
                    imageLabel: 'payments.png',
                    tileLabel: 'Payments',
                    pageRoute: AdvisorPaymentsScreen.routeName,
                  ),
                ],
              ),
            ),
            AnswerQuestionTile()
          ],
        ),
      ),
    );
  }
}
