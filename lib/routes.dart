import 'package:flutter/material.dart';
import './screens/screens.dart';

Map<String, Widget Function(BuildContext)> routes = {
  ScreenDecider.routeName: (ctx) => ScreenDecider(),
  SplashScreen.routeName: (ctx) => SplashScreen(),
  AuthScreen.routeName: (ctx) => AuthScreen(),
  AdvisorDashboardScreen.routeName: (ctx) => AdvisorDashboardScreen(),
  AdvisorProfileScreen.routeName: (ctx) => AdvisorProfileScreen(),
  AdvisorMenteesScreen.routeName: (ctx) => AdvisorMenteesScreen(),
  AdvisorMenteeDetailScreen.routeName: (ctx) => AdvisorMenteeDetailScreen(),
  AdvisorScheduleScreen.routeName: (ctx) => AdvisorScheduleScreen(),
  AdvisorReviewsScreen.routeName: (ctx) => AdvisorReviewsScreen(),
  AdvisorPaymentsScreen.routeName: (ctx) => AdvisorPaymentsScreen(),
  StudentDashboardScreen.routeName: (ctx) => StudentDashboardScreen(),
  StudentHomeScreen.routeName: (ctx) => StudentHomeScreen(),
  StudentCompetitiveScreen.routeName: (ctx) => StudentCompetitiveScreen(),
  StudentCollegesScreen.routeName: (ctx) => StudentCollegesScreen(),
  StudentExpertiseScreen.routeName: (ctx) => StudentExpertiseScreen(),
  StudentMessagesScreen.routeName: (ctx) => StudentMessagesScreen(),
  StudentSettingsScreen.routeName: (ctx) => StudentSettingsScreen(),
  StudentAdvisorScreen.routeName: (ctx) => StudentAdvisorScreen(),
  StudentAdvisorDetailScreen.routeName: (ctx) => StudentAdvisorDetailScreen(),
  StudentTimeScreen.routeName: (ctx) => StudentTimeScreen(),
  StudentSlotScreen.routeName: (ctx) => StudentSlotScreen(),
};
