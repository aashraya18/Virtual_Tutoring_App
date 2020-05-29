import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';
import './signupVerify_screen.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _signUpForm = GlobalKey<FormState>();

  final _nameTextCont = TextEditingController();
  final _emailTextCont = TextEditingController();
  final _passwordTextCont = TextEditingController();

  bool _loading = false;

  Future<void> _signUp() async {
    if (!_signUpForm.currentState.validate()) return;
    setState(() {
      _loading = true;
    });
    try {
      final authData = Provider.of<AuthProvider>(context, listen: false);
      await authData.saveUserDetails(
          _emailTextCont.text, _passwordTextCont.text, _nameTextCont.text);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => SignUpVerifyScreen(_nameTextCont.text)));
    } catch (error) {}

    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Form(
      key: _signUpForm,
      child: Column(
        children: <Widget>[
          _buildNameTTF(),
          _buildEmailTTF(),
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

  Widget _buildNameTTF() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.5),
      child: Card(
        elevation: 2,
        child: TextFormField(
          controller: _nameTextCont,
          decoration: InputDecoration(
            labelText: 'Full Name',
            suffixIcon: Icon(Icons.person),
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty || value.length < 5)
              return 'Enter your full name';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildEmailTTF() {
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
            suffixIcon: Icon(Icons.email),
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
            suffixIcon: Icon(Icons.remove_red_eye),
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
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
      onTap: _signUp,
    );
  }
}
