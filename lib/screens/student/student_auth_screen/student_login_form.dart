import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:otp_text_field/otp_text_field.dart';

import '../../../services/auth_provider.dart';
import '../../../common_widgets/platformExceptionAlertDialog.dart';

class StudentLoginForm extends StatefulWidget {
  @override
  _StudentLoginFormState createState() => _StudentLoginFormState();
}

class _StudentLoginFormState extends State<StudentLoginForm> {
  final _loginForm = GlobalKey<FormState>();
  final _phoneTextCont = TextEditingController();

  String _countryCode;
  bool _otpSent = false;
  bool loading = false;

  Future<void> _sendOTP() async {
    // Validating phone text field.
    if (!_loginForm.currentState.validate()) return;

    setState(() {
      loading = true;
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

      loading = false;
    } catch (error) {
      setState(() {
        loading = false;
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
        loading = true;
      });
      final authCredential = auth.otpVerification(smsCode);
      await auth.signInWithCredential(authCredential);
      Navigator.of(context).pop();
      loading = false;
    } on PlatformException catch (error) {
      setState(() {
        loading = false;
      });
      print(error.code);
      print(error.details);
      print(error.message);
      // Showing error dialog.
      /* PlatformExceptionAlertDialog(
        title: 'Signin error',
        exception: error,
      ).show(context); */
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Form(
      key: _loginForm,
      child: Column(
        children: <Widget>[
          _buildPhoneTTF(),
          _buildSendOtpButton(constraints),
          if (_otpSent) _buildOTPFields(),
          if (_otpSent && loading) CircularProgressIndicator(),
        ],
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
            child: loading
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
      child: OTPTextField(
        width: MediaQuery.of(context).size.width,
        keyboardType: TextInputType.number,
        length: 6,
        onCompleted: _otpVerification,
      ),
    );
  }
}
