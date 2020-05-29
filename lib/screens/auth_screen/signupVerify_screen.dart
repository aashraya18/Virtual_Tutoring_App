import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';

enum Process {
  notStarted,
  otpSent,
  completed,
}

class SignUpVerifyScreen extends StatefulWidget {
  final String fullName;

  SignUpVerifyScreen(this.fullName);
  @override
  _SignUpVerifyScreenState createState() => _SignUpVerifyScreenState();
}

class _SignUpVerifyScreenState extends State<SignUpVerifyScreen> {
  Process _mode = Process.notStarted;

  final _phoneKey = GlobalKey<FormState>();
  final _otpKey = GlobalKey<FormState>();

  final _phoneNumberTextCont = TextEditingController();
  final _otpNumberTextCont = TextEditingController();

  Future<void> _startVerification() async {
    if (!_phoneKey.currentState.validate()) return;
    final authData = Provider.of<AuthProvider>(context, listen: false);
    final success =
        await authData.verifyPhoneNumber('+91${_phoneNumberTextCont.text}');
    if (!success) return;
    setState(() {
      _mode = Process.otpSent;
    });
  }

  Future<void> _completeVerification() async {
    if (!_otpKey.currentState.validate()) return;
    final authData = Provider.of<AuthProvider>(context, listen: false);
    await authData.otpVerification(_otpNumberTextCont.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Phone Number'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          _buildWelcomeContainer(constraints),
          _currentDisplay(),
        ],
      ),
    );
  }

  Widget _buildWelcomeContainer(Size constraints) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          color: Theme.of(context).primaryColor),
      height: constraints.height * 0.3,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(15),
            child: Text(
              'Hey ${widget.fullName}!!',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(15),
            child: Text(
              'Welcome!\nPlease complete the phone verification.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _currentDisplay() {
    switch (_mode) {
      case Process.notStarted:
        {
          return _buildNotStarted();
        }
      case Process.otpSent:
        {
          return _buildOtpSent();
        }
      default:
        {
          return _buildNotStarted();
        }
    }
  }

  Widget _buildNotStarted() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _phoneKey,
            child: TextFormField(
              controller: _phoneNumberTextCont,
              decoration: InputDecoration(
                labelText: 'Enter phone Number',
                hintText: 'Without +91',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value.isEmpty || value.length != 10) return 'Enter number';
                return null;
              },
            ),
          ),
        ),
        RaisedButton(
          child: Text(
            'Submit',
            style: TextStyle(fontSize: 17),
          ),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: _startVerification,
        ),
      ],
    );
  }

  Widget _buildOtpSent() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _otpKey,
            child: TextFormField(
              controller: _otpNumberTextCont,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (value) {
                if (value.isEmpty || value.length != 6)
                  return 'Enter otp correctly';
                return null;
              },
            ),
          ),
        ),
        RaisedButton(
          child: Text(
            'Verify',
            style: TextStyle(fontSize: 17),
          ),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: _completeVerification,
        ),
      ],
    );
  }
}
