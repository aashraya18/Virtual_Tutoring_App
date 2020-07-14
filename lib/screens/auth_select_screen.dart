import 'package:flutter/material.dart';

import 'student/student_auth_screen/student_auth_screen.dart';
import 'advisor/advisor_auth_screen/advisor_auth_screen.dart';

class AuthSelectScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            width: double.infinity,
            color: Color.fromRGBO(66, 133, 140, 1),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: constraints.height * 0.2,
                    width: constraints.height * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/empty_user.jpg')),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Student',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed(StudentAuthScreen.routeName);
              },
            ),
          )),
          Expanded(
              child: Container(
            width: double.infinity,
            color: Color.fromRGBO(253, 176, 94, 1),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: constraints.height * 0.2,
                    width: constraints.height * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/empty_user.jpg')),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Advisor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed(AdvisorAuthScreen.routeName);
              },
            ),
          )),
        ],
      ),
    );
  }
}
