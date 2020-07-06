//import 'package:android/notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth_provider.dart';
import 'services/student_database_provider.dart';
import 'services/advisor_database_provider.dart';
import 'services/chat_provider.dart';
import 'routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return /*MaterialApp(
      home: FirebaseNotification(),
    );*/
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ProxyProvider<AuthProvider, StudentDatabaseProvider>(
          update: (ctx, auth, database) =>
              StudentDatabaseProvider(auth.student),
        ),
        ProxyProvider<AuthProvider, AdvisorDatabaseProvider>(
          update: (ctx, auth, database) =>
              AdvisorDatabaseProvider(auth.advisor),
        ),
        Provider(create: (ctx) => ChatProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Vorby',
            theme: auth.themeData,
            routes: routes,
          );
        },
      ),
    );
  }
}
