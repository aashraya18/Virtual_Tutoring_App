import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:otp_text_field/otp_text_field.dart';

import '../../../services/auth_provider.dart';
import '../../../common_widgets/platformExceptionAlertDialog.dart';

class StudentSignUpForm extends StatefulWidget {
  @override
  _StudentSignUpFormState createState() => _StudentSignUpFormState();
}

class _StudentSignUpFormState extends State<StudentSignUpForm> {
  final _signUpForm = GlobalKey<FormState>();

  final _nameTextCont = TextEditingController();
  final _emailTextCont = TextEditingController();
  final _phoneTextCont = TextEditingController();

  bool _sendingOtp = false;
  bool _otpSent = false;
  bool _verifying = false;

  String _countryCode;

  Future<void> _sendOTP() async {
    // Validating phone text field.
    if (!_signUpForm.currentState.validate()) return;

    setState(() {
      _sendingOtp = true;
    });

    // Clearing focus.
    FocusScope.of(context).unfocus();

    try {
      // Initiating phone authentication process.
      final authData = Provider.of<AuthProvider>(context, listen: false);
      await authData.verifyPhoneNumber('$_countryCode${_phoneTextCont.text}');

      //Showing snackbar.
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('OTP sent.'),
      ));

      setState(() {
        _otpSent = true;
      });

      _sendingOtp = false;
    } catch (error) {
      setState(() {
        _sendingOtp = false;
      });

      // Showing error dialog.
      PlatformExceptionAlertDialog(
        title: 'Signin error',
        exception: error,
      ).show(context);
    }
  }

  Future<void> _otpVerification(String smsCode) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        _verifying = true;
      });
      final authCredential = auth.otpVerification(smsCode);
      await auth.createUserWithAuthCredential(
          authCredential, _emailTextCont.text, _nameTextCont.text);
      Navigator.of(context).pop();
      _verifying = false;
    } on PlatformException catch (error) {
      setState(() {
        _verifying = false;
      });
      // Showing error dialog.
      PlatformExceptionAlertDialog(
        title: 'Signin error',
        exception: error,
      ).show(context);
    } catch (error) {
      setState(() {
        _verifying = false;
      });
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Form(
      key: _signUpForm,
      child: Column(
        children: <Widget>[
          if (!_otpSent) _buildNameTTF(),
          if (!_otpSent) _buildEmailTTF(),
          if (!_otpSent) _buildPhoneTTF(),
          if (!_otpSent) _buildSendOtpButton(constraints),
          if (_otpSent) _buildOTPFields(),
          if (_verifying)
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildNameTTF() {
    return Padding(
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
            if (value.isEmpty) return 'Enter your full name';
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.5),
      child: Card(
        elevation: 2,
        child: TextFormField(
          controller: _emailTextCont,
          decoration: InputDecoration(
            labelText: 'Email',
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.email),
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

  Widget _buildPhoneTTF() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          CountryCodePicker(
            initialSelection: '+91',
            onInit: (code) {
              _countryCode = code.dialCode;
            },
            onChanged: (code) {
              _countryCode = code.dialCode;
            },
          ),
          Expanded(
            child: Card(
              elevation: 2,
              child: TextFormField(
                controller: _phoneTextCont,
                enabled: !_otpSent,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  suffixIcon: Icon(Icons.phone),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value.isEmpty) return 'Enter phone number.';
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendOtpButton(Size constraints) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            width: constraints.width,
            color: Color.fromRGBO(66, 133, 140, 1),
            alignment: Alignment.center,
            child: _sendingOtp
                ? CircularProgressIndicator()
                : Text(
                    'Send Otp',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        onTap: _otpSent ? null : _sendOTP,
      ),
    );
  }

  Widget _buildOTPFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          Text('Enter OTP'),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OTPTextField(
                width: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                length: 6,
                onCompleted: _otpVerification,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
