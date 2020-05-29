import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Image.asset(
          'assets/images/vorby/white_bg.png',
          height: height * 0.15,
          width: width * 0.5,
        ),
      ),
    );
  }
}
