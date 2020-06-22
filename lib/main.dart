import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/services.dart';
import './routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ProxyProvider<AuthProvider, DatabaseProvider>(
          update: (ctx, auth, database) => DatabaseProvider(auth.student),
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
