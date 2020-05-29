import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';
import './login_form.dart';
import './signup_form.dart';

enum Mode {
  login,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Mode _mode = Mode.login;

  Future<void> _googleSignIn() async {
    final authData = Provider.of<AuthProvider>(context, listen: false);
    await authData.signInWithGoogle();
  }

  Future<void> _facebookSignIn() async {
    final authData = Provider.of<AuthProvider>(context, listen: false);
    await authData.signInWithFacebook();
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildLogo(constraints),
            Container(
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
            ),
            if (_mode == Mode.login) LoginForm(),
            if (_mode == Mode.signup) SignUpForm(),
            _buildDividerLine(),
            SizedBox(
              height: 20,
            ),
            _buildSignInMethods(),
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

  Widget _buildDividerLine() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        Text(
          _mode == Mode.login
              ? '     Login with     '
              : '     SignUp with     ',
          style: TextStyle(color: Colors.black54),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInMethods() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: Image.asset(
            'assets/images/google-logo.png',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
          onTap: _googleSignIn,
        ),
        SizedBox(
          width: 20,
        ),
        GestureDetector(
          child: Image.asset(
            'assets/images/facebook-logo.png',
            color: Theme.of(context).primaryColor,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
          onTap: _facebookSignIn,
        ),
      ],
    );
  }
}
