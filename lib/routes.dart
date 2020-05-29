import 'package:flutter/material.dart';
import './screens/screens.dart';

Map<String, Widget Function(BuildContext)> routes = {
  ScreenDecider.routeName: (ctx) => ScreenDecider(),
  SplashScreen.routeName: (ctx) => SplashScreen(),
  AuthScreen.routeName: (ctx) => AuthScreen(),
  AdvisorHomeScreen.routeName: (ctx) => AdvisorHomeScreen(),
  AdvisorProfileScreen.routeName: (ctx) => AdvisorProfileScreen(),
  AdvisorMenteesScreen.routeName: (ctx) => AdvisorMenteesScreen(),
  AdvisorMenteeDetailScreen.routeName: (ctx) => AdvisorMenteeDetailScreen(),
  AdvisorScheduleScreen.routeName: (ctx) => AdvisorScheduleScreen(),
  AdvisorReviewsScreen.routeName: (ctx) => AdvisorReviewsScreen(),
  AdvisorPaymentsScreen.routeName: (ctx) => AdvisorPaymentsScreen(),
};
