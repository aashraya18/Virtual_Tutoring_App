import 'package:android/screens/advisor/advisor_ask_me/ask_me_screen.dart';
import 'package:android/screens/advisor/advisor_ask_me/submit_answer.dart';
import 'package:flutter/material.dart';
import 'screens/screens.dart';

Map<String, Widget Function(BuildContext)> routes = {
  ScreenDecider.routeName: (ctx) => ScreenDecider(),
  SplashScreen.routeName: (ctx) => SplashScreen(),
  AuthSelectScreen.routeName: (ctx) => AdvisorAuthScreen(),
  //ADMIN
  AllAdvisordetails.routeName: (ctx) =>AllAdvisordetails(),
  //ADVISORS
  AdvisorAuthScreen.routeName: (ctx) => AdvisorAuthScreen(),
  AdvisorForgotScreen.routeName: (ctx) => AdvisorForgotScreen(),
  AdvisorDashboardScreen.routeName: (ctx) => AdvisorDashboardScreen(),
  AdvisorProfileScreen.routeName: (ctx) => AdvisorProfileScreen(),
  AdvisorMenteesScreen.routeName: (ctx) => AdvisorMenteesScreen(),
  AdvisorMenteeDetailScreen.routeName: (ctx) => AdvisorMenteeDetailScreen(),
  AdvisorScheduleScreen.routeName: (ctx) => AdvisorScheduleScreen(),
  AdvisorReviewsScreen.routeName: (ctx) => AdvisorReviewsScreen(),
  AdvisorPaymentsScreen.routeName: (ctx) => AdvisorPaymentsScreen(),
  AdvisorChatScreen.routeName: (ctx) => AdvisorChatScreen(),
  AskMeScreen.routeName: (ctx) => AskMeScreen(),
  SubmitAnswer.routeName: (ctx) => SubmitAnswer(),
  //STUDENTS
  StudentAuthScreen.routeName: (ctx) => StudentAuthScreen(),
  StudentDashboardScreen.routeName: (ctx) => StudentDashboardScreen(),
  StudentHomeScreen.routeName: (ctx) => StudentHomeScreen(),
  StudentCompetitiveScreen.routeName: (ctx) => StudentCompetitiveScreen(),
  StudentCollegesScreen.routeName: (ctx) => StudentCollegesScreen(),
  StudentExpertiseScreen.routeName: (ctx) => StudentExpertiseScreen(),
  StudentGuidesScreen.routeName: (ctx) => StudentGuidesScreen(),
  StudentSettingsScreen.routeName: (ctx) => StudentSettingsScreen(),
  StudentAdvisorScreen.routeName: (ctx) => StudentAdvisorScreen(),
  StudentAdvisorDetailScreen.routeName: (ctx) => StudentAdvisorDetailScreen(),
  StudentTimeScreen.routeName: (ctx) => StudentTimeScreen(),
  StudentSlotScreen.routeName: (ctx) => StudentSlotScreen(),
  StudentChatScreen.routeName: (ctx) => StudentChatScreen(),
  StudentFeedbackScreen.routeName: (ctx) => StudentFeedbackScreen(),
  StudentCallScreen.routeName: (ctx) => StudentCallScreen(),
};
