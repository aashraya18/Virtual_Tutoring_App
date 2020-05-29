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
        Provider(create: (ctx) => DatabaseProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(66, 133, 140, 1),
          accentColor: Colors.white,
          canvasColor: Colors.white,
          fontFamily: 'Literal',
          textTheme: TextTheme(headline6: TextStyle(fontSize: 20)),
          appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black54),
              textTheme: TextTheme(
                headline6: TextStyle(
                    color: Color.fromRGBO(66, 133, 140, 1), fontSize: 22),
              )),
        ),
        routes: routes,
      ),
    );
  }
}
