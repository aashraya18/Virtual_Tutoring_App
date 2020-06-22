import 'package:flutter/material.dart';

import './advisor_login_form.dart';
import './advisor_forgot_screen.dart';

class AdvisorAuthScreen extends StatelessWidget {
  static const routeName = '/auth-advisor';

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildLogo(constraints),
            _buildLoginButton(),
            AdvisorLoginForm(),
            _buildForgetPassword(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(Size constraints) {
    return Image.asset(
      'assets/images/vorby/no_bg.png',
      height: constraints.height * 0.20,
      width: constraints.width * 0.55,
      fit: BoxFit.cover,
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Card(
        elevation: 3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Advisor Login',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black54,
                ),
              ),
            ),
            Container(
              height: 3,
              color: Color.fromRGBO(33, 213, 207, 1),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildForgetPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: GestureDetector(
        child: Container(
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        onTap: () =>
            Navigator.of(context).pushNamed(AdvisorForgotScreen.routeName),
      ),
    );
  }
}
