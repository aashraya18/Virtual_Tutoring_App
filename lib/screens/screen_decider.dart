import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android/screens/admin/advisor_details.dart';
import '../services/auth_provider.dart';

import './auth_select_screen.dart';
import './student/student_dashboard_screen/student_dashboard_screen.dart';
import './advisor/advisor_dashboard_screen/advisor_dashboard_screen.dart';
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
    //return AllAdvisordetails();
    if (role == true) {
      if (advisor != null)
        return AdvisorDashboardScreen();
      else
        return AuthSelectScreen();
    } else if (role == false) {
      if (student != null)
        return StudentDashboardScreen();
      else
        return AuthSelectScreen();
    } else
      return SplashScreen();
  }
}
