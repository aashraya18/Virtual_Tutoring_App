import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_provider.dart';
import './auth_screen/auth_screen.dart';
import './student/student_dashboard_screen/student_dashboard_screen.dart';
import './advisor/advisor_home_screen/advisor_home_screen.dart';
import './splash_screen.dart';

class ScreenDecider extends StatefulWidget {
  static const routeName = '/';

  @override
  _ScreenDeciderState createState() => _ScreenDeciderState();
}

class _ScreenDeciderState extends State<ScreenDecider> {
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).currentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);
    final role = authData.role;
    final advisor = authData.advisor;
    final student = authData.student;

    if (role == true) {
      if (advisor != null)
        return AdvisorHomeScreen();
      else
        return AuthScreen();
    } else if (role == false) {
      if (student != null)
        return StudentDashboardScreen();
      else
        return AuthScreen();
    } else
      return SplashScreen();
  }
}
