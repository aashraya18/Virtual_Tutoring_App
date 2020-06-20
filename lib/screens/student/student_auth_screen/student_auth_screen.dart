import 'package:flutter/material.dart';

import './student_login_form.dart';
import './student_signup_form.dart';

enum Mode {
  login,
  signup,
}

class StudentAuthScreen extends StatefulWidget {
  static const routeName = '/auth-student';
  @override
  _StudentAuthScreenState createState() => _StudentAuthScreenState();
}

class _StudentAuthScreenState extends State<StudentAuthScreen> {
  Mode _mode = Mode.login;

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
            _buildSelectMode(),
            if (_mode == Mode.login) StudentLoginForm(),
            if (_mode == Mode.signup) StudentSignUpForm(),
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

  Widget _buildSelectMode() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Card(
        elevation: 3,
        child: Row(
          children: <Widget>[
            _buildLoginButton(),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Expanded(
      child: FlatButton(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black54,
                ),
              ),
            ),
            if (_mode == Mode.login)
              Container(
                height: 3,
                color: Color.fromRGBO(33, 213, 207, 1),
              )
          ],
        ),
        onPressed: _mode == Mode.login
            ? null
            : () {
                setState(() {
                  _mode = Mode.login;
                });
              },
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Expanded(
      child: FlatButton(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black54,
                ),
              ),
            ),
            if (_mode == Mode.signup)
              Container(
                height: 3,
                color: Color.fromRGBO(33, 213, 207, 1),
              ),
          ],
        ),
        onPressed: _mode == Mode.signup
            ? null
            : () {
                setState(() {
                  _mode = Mode.signup;
                });
              },
      ),
    );
  }
}
