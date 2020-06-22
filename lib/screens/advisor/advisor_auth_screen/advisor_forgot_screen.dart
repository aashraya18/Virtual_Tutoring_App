import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../services/auth_provider.dart';
import '../../../common_widgets/platformExceptionAlertDialog.dart';

class AdvisorForgotScreen extends StatefulWidget {
  static const routeName = '/advisor-forgot';
  @override
  _AdvisorForgotScreenState createState() => _AdvisorForgotScreenState();
}

class _AdvisorForgotScreenState extends State<AdvisorForgotScreen> {
  final _forgotForm = GlobalKey<FormState>();
  final _emailTextCont = TextEditingController();

  bool _loading = false;

  Future<void> _forgotPassword() async {
    // Validate email
    if (!_forgotForm.currentState.validate()) return;

    // Set loading to true
    setState(() {
      _loading = true;
    });

    try {
      // Send Password reset email
      await Provider.of<AuthProvider>(context, listen: false)
          .sendPasswordResetEmail(_emailTextCont.text);

      // Show toast
      Fluttertoast.showToast(msg: 'Reset link sent to email.');

      // Pop route and set loading to false.
      Navigator.of(context).pop();
      _loading = false;
    } catch (error) {
      //Oon error set loading to false
      setState(() {
        _loading = false;
      });

      // Show eror dialog.
      PlatformExceptionAlertDialog(
        exception: error,
        title: 'Could not send.',
      ).show(context);
    }
  }

  @override
  void dispose() {
    _emailTextCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Form(
        key: _forgotForm,
        child: Column(
          children: <Widget>[
            _buildEmailTTF(),
            _buildLoginButton(constraints),
          ],
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

  Widget _buildLoginButton(Size constraints) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.5),
      child: GestureDetector(
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
                      'Send Reset Link',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          onTap: _forgotPassword),
    );
  }
}
