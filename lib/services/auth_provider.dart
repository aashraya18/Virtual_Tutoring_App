import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import './firestore_service.dart';
import '../models/student_model.dart';
import '../models/advisor_model.dart';

abstract class AuthBase {
  Future<void> currentUser();
  Future<void> saveUserDetails(String email, String password, String fullName);
  Future<bool> verifyPhoneNumber(String phoneNumber);
  Future<void> otpVerification(String smsCode);
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signInWithFacebook();
  Future<void> signOut();
}

class AuthProvider extends ChangeNotifier implements AuthBase {
  final _firebaseAuthService = FirebaseAuth.instance;
  final _firestoreService = FirestoreService.instance;

  Student _student;
  Student get student {
    return _student;
  }

  Advisor _advisor;
  Advisor get advisor {
    return _advisor;
  }

  bool _role;

  bool get role {
    return _role;
  }

  Future<void> currentUser() async {
    final user = await _firebaseAuthService.currentUser();
    if (user == null) {
      _role = false;
      notifyListeners();
      return;
    }

    final advisorData =
        await _firestoreService.getData(docPath: 'helpers/${user.email}');
    if (advisorData.exists) {
      _advisor = Advisor(
        uid: user.uid,
        about: advisorData['about'],
        branch: advisorData['branch'],
        college: advisorData['college'],
        displayName: advisorData['displayName'],
        email: user.email,
        phoneNumber: advisorData['phoneNumber'],
        photoUrl: advisorData['photoUrl'],
      );
      _role = true;
    } else {
      final studentData =
          await _firestoreService.getData(docPath: 'students/${user.uid}');
      _student = Student(
        displayName: studentData['displayName'],
        photoUrl: studentData['photoUrl'],
        email: user.email,
        uid: user.uid,
      );
      _role = false;
    }
    notifyListeners();
  }

  String _email;
  String _password;

  String _verificationId;

  Future<void> saveUserDetails(
      String email, String password, String fullName) async {
    _email = email;
    _password = password;
    notifyListeners();
  }

  Future<bool> verifyPhoneNumber(String phoneNumber) async {
    try {
      final verificationFailed = (AuthException authException) {
        print(authException.message);
        throw PlatformException(code: 'VERIFICATION_FAILED');
      };

      void verificationCompleted(AuthCredential authCredential) {
        print('success');
      }

      await _firebaseAuthService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 0),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (String verId, [int forceResendToken]) async {
          _verificationId = verId;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verId) async {
          _verificationId = verId;
          notifyListeners();
        },
      );
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<void> otpVerification(String smsCode) async {
    try {
      final authCredenntial = PhoneAuthProvider.getCredential(
          verificationId: _verificationId, smsCode: smsCode);
      await _firebaseAuthService.createUserWithEmailAndPassword(
          email: _email, password: _password);
      final oldUser = await _firebaseAuthService.currentUser();
      final authResult = await oldUser.linkWithCredential(authCredenntial);
      final user = authResult.user;
      _student = Student(
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        email: user.email,
        uid: user.uid,
      );
      _role = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final authResult = await _firebaseAuthService.signInWithEmailAndPassword(
          email: email, password: password);

      final user = authResult.user;
      final advisorData =
          await _firestoreService.getData(docPath: 'helpers/$email');

      if (advisorData.exists) {
        _advisor = Advisor(
          uid: user.uid,
          about: advisorData['about'],
          branch: advisorData['branch'],
          college: advisorData['college'],
          displayName: advisorData['displayName'],
          email: user.email,
          phoneNumber: advisorData['phoneNumber'],
          photoUrl: advisorData['photoUrl'],
        );
        _role = true;
      } else {
        final studentData =
            await _firestoreService.getData(docPath: 'students/${user.uid}');
        _student = Student(
          displayName: studentData['displayName'],
          photoUrl: studentData['photoUrl'],
          email: user.email,
          uid: user.uid,
        );
        _role = false;
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleAccount = await GoogleSignIn().signIn();
      final googleAuth = await googleAccount.authentication;
      final authResult = await _firebaseAuthService.signInWithCredential(
          GoogleAuthProvider.getCredential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken));
      final user = authResult.user;
      final studentData =
          await _firestoreService.getData(docPath: 'students/${user.uid}');
      _student = Student(
        displayName: studentData['displayName'],
        photoUrl: studentData['photoUrl'],
        email: user.email,
        uid: user.uid,
      );
      _role = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final facebookAccount =
          await FacebookLogin().logIn(['public_profile', 'email']);
      final authResult = await _firebaseAuthService.signInWithCredential(
          FacebookAuthProvider.getCredential(
              accessToken: facebookAccount.accessToken.token));
      final user = authResult.user;
      final studentData =
          await _firestoreService.getData(docPath: 'students/${user.uid}');
      _student = Student(
        displayName: studentData['displayName'],
        photoUrl: studentData['photoUrl'],
        email: user.email,
        uid: user.uid,
      );
      _role = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
    await GoogleSignIn().signOut();
    await FacebookLogin().logOut();
    _advisor = null;
    _student = null;
    _role = false;
    notifyListeners();
  }
}
