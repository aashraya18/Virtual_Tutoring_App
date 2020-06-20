import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../services/auth_provider.dart';
import '../../../common_widgets/platformExceptionAlertDialog.dart';

class AdvisorLoginForm extends StatefulWidget {
  @override
  _AdvisorLoginFormState createState() => _AdvisorLoginFormState();
}

class _AdvisorLoginFormState extends State<AdvisorLoginForm> {
  final _loginForm = GlobalKey<FormState>();

  final _emailTextCont = TextEditingController();
  final _passwordTextCont = TextEditingController();

  bool _loading = false;

  Future<void> _login() async {
    // Validate Email and Password fields.
    if (!_loginForm.currentState.validate()) return;

    // Set loading to true
    setState(() {
      _loading = true;
    });
    try {
      // Try logging in with email and password.
      await Provider.of<AuthProvider>(context, listen: false)
          .signInWithEmailAndPassword(
              _emailTextCont.text, _passwordTextCont.text);

      // Pop route and set loading to false.
      Navigator.of(context).pop();
      _loading = false;
    } catch (error) {
      // On error set loading to false.
      setState(() {
        _loading = false;
      });

      // Show error dialog.
      PlatformExceptionAlertDialog(
        title: 'Signin error',
        exception: error,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Form(
      key: _loginForm,
      child: Column(
        children: <Widget>[
          _buildUserNameTTF(),
          _buildPasswordTTF(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 12.5,
            ),
            child: _buildLoginButton(constraints),
          ),
        ],
      ),
    );
  }

  Widget _buildUserNameTTF() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.5),
      child: Card(
        elevation: 2,
        child: TextFormField(
          controller: _emailTextCont,
          decoration: InputDecoration(
            labelText: 'Email',
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value.isEmpty) return 'Enter email';
            if (!regex.hasMatch(value)) return 'Enter valid email.';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildPasswordTTF() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.5),
      child: Card(
        elevation: 2,
        child: TextFormField(
          controller: _passwordTextCont,
          decoration: InputDecoration(
            labelText: 'Password',
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
          ),
          obscureText: true,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) return 'Enter a password';
            if (value.length < 8) return 'Minimum 8 chars required';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildLoginButton(Size constraints) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          width: constraints.width,
          color: Color.fromRGBO(66, 133, 140, 1),
          alignment: Alignment.center,
          child: _loading
              ? CircularProgressIndicator()
              : Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
      onTap: _login,
    );
  }
}
