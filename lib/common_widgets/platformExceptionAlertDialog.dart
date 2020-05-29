import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './platformAlertDialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required this.title,
    @required this.exception,
  }) : super(
          title: title,
          content: _message(exception),
          defaultActionText: 'OK',
        );

  final String title;
  final PlatformException exception;

  static _message(PlatformException exception) {
    return _errors[exception.code];
  }

  static Map<String, String> _errors = {
    'ERROR_INVALID_EMAIL': 'Email or Password is incorrect',
    'ERROR_WRONG_PASSWORD': 'Email or Password is incorrect',
    'ERROR_USER_NOT_FOUND': 'Please signup first',
    'ERROR_USER_DISABLED': 'You are disabled from using the app',
    'ERROR_TOO_MANY_REQUESTS': 'You have tried so many times. Try again later.',
    'ERROR_OPERATION_NOT_ALLOWED': 'Contact Admin. Method Disabled',
    'ERROR_EMAIL_ALREADY_IN_USE': 'Email already registered. Please Sign In.',
    'ERROR_WEAK_PASSWORD': 'Please enter a strong password',
    'ERROR_INVALID_CUSTOM_TOKEN': 'Custom Token Invalid',
    'ERROR_CUSTOM_TOKEN_MISMATCH': 'Custom Token Mismatch',
    'ERROR_INVALID_CREDENTIAL': 'Enter correct email address',
    'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        'Sign in with the previous method',
    'VERIFICATION_FAILED': 'Phone verification failed',
  };
}
