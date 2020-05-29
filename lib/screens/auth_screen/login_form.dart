import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginForm = GlobalKey<FormState>();

  final _emailTextCont = TextEditingController();
  final _passwordTextCont = TextEditingController();

  bool loading = false;

  Future<void> _login() async {
    if (!_loginForm.currentState.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      final authData = Provider.of<AuthProvider>(context, listen: false);
      await authData.signInWithEmailAndPassword(
          _emailTextCont.text, _passwordTextCont.text);
      loading = false;
    } on PlatformException catch (error) {
      String errorMessage;
      if (error.code == 'ERROR_INVALID_EMAIL') errorMessage = 'Invalid Email';
      if (error.code == 'ERROR_WRONG_PASSWORD') errorMessage = 'Wrong Password';
      if (error.code == 'ERROR_USER_NOT_FOUND') errorMessage = 'No user found.';
      if (error.code == 'ERROR_USER_DISABLED')
        errorMessage = 'User has been disbled';
      if (error.code == 'ERROR_TOO_MANY_REQUESTS')
        errorMessage = 'Too many attempts to sign in.';
      if (error.code == 'ERROR_OPERATION_NOT_ALLOWED')
        errorMessage = 'This mode not available';

      print(errorMessage);
      setState(() {
        loading = false;
      });
    } catch (error) {
      print(error.toString());
      setState(() {
        loading = false;
      });
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
            padding: const EdgeInsets.all(25.0),
            child: _buildForgetPassword(),
          ),
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

  Widget _buildForgetPassword() {
    return Container(
      child: Text(
        'Forgot Password?',
        style: TextStyle(color: Colors.black54),
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
          child: loading
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
