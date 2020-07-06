import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firestore_service.dart';
import '../models/student_model.dart';
import '../models/advisor_model.dart';

class AuthProvider extends ChangeNotifier {
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

  ThemeData _themeData = studentTheme;
  ThemeData get themeData {
    return _themeData;
  }

  Future<void> currentUser() async {
    try {
      final user = await _firebaseAuthService
          .currentUser()
          .timeout(const Duration(seconds: 5));
      if (user == null) {
        _role = false;
        notifyListeners();
        return;
      }

      final advisorData =
          await _firestoreService.getData(docPath: 'helpers/${user.email}');
      if (advisorData.exists) {
        _advisor = Advisor(
          about: advisorData['about'],
          branch: advisorData['branch'],
          college: advisorData['college'],
          displayName: advisorData['displayName'],
          email: user.email,
          menteesCount: advisorData['menteesCount'],
          phoneNumber: advisorData['phoneNumber'],
          photoUrl: advisorData['photoUrl'],
          rating: advisorData['rating'],
          reviewsCount: advisorData['reviewsCount'],
          uid: user.uid,
        );
        _role = true;
        _themeData = advisorTheme;
      } else {
        final studentData =
            await _firestoreService.getData(docPath: 'students/${user.uid}');
        _student = Student(
          bio: studentData['bio'],
          displayName: studentData['displayName'],
          email: user.email,
          phoneNumber: studentData['phoneNumber'],
          photoUrl: studentData['photoUrl'],
          uid: user.uid,
        );
        _role = false;
        _themeData = studentTheme;
      }
      notifyListeners();
    } catch (error) {
      _role = false;
      _student = null;
      _advisor = null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuthService.sendPasswordResetEmail(email: email);
    } catch (error) {
      throw error;
    }
  }

  String _verificationId;
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      final verificationFailed =
          (AuthException authException) => throw authException;

      void verificationCompleted(AuthCredential authCredential) {}

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
    } catch (error) {
      throw error;
    }
  }

  AuthCredential otpVerification(String smsCode) {
    try {
      final authCredential = PhoneAuthProvider.getCredential(
          verificationId: _verificationId, smsCode: smsCode);

      return authCredential;
    } catch (error) {
      throw error;
    }
  }

  Future<void> createUserWithAuthCredential(
      AuthCredential authCredential, String email, String displayName) async {
    try {
      final authResult =
          await _firebaseAuthService.signInWithCredential(authCredential);
      final user = authResult.user;

      await _firestoreService
          .updateData(docPath: 'students/${user.uid}', data: {
        'bio': 'Hello, this is $displayName.',
        'displayName': displayName,
        'email': email,
        'phoneNumber': '${user.phoneNumber}',
        'photoUrl':
            'https://firebasestorage.googleapis.com/v0/b/vorbyapp.appspot.com/o/empty_user.jpg?alt=media&token=b3c39bcf-2baa-444a-b739-c85aba5cc220',
      });
      _student = Student(
        bio: 'Hello, this is $displayName.',
        displayName: displayName,
        email: email,
        phoneNumber: '${user.phoneNumber}',
        photoUrl:
            'https://firebasestorage.googleapis.com/v0/b/vorbyapp.appspot.com/o/empty_user.jpg?alt=media&token=b3c39bcf-2baa-444a-b739-c85aba5cc220',
        uid: '${user.uid}',
      );
      _role = false;
      _themeData = studentTheme;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signInWithCredential(AuthCredential authCredential) async {
    try {
      final authResult =
          await _firebaseAuthService.signInWithCredential(authCredential);
      final user = authResult.user;
      final studentData =
          await _firestoreService.getData(docPath: 'students/${user.uid}');
      if (studentData.exists) {
        _student = Student(
          bio: studentData['bio'],
          displayName: studentData['displayName'],
          email: studentData['email'],
          phoneNumber: studentData['phoneNumber'],
          photoUrl: studentData['photoUrl'],
          uid: user.uid,
        );
        _role = false;
        _themeData = studentTheme;
        notifyListeners();
      } else {
        throw PlatformException(code: 'ERROR_USER_NOT_FOUND');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try {
      final authResult = await _firebaseAuthService.signInWithEmailAndPassword(
          email: email, password: password);

      final user = authResult.user;
      final advisorData =
          await _firestoreService.getData(docPath: 'helpers/$email');

      if (advisorData.exists) {
        _advisor = Advisor(
          about: advisorData['about'],
          branch: advisorData['branch'],
          college: advisorData['college'],
          displayName: advisorData['displayName'],
          email: user.email,
          menteesCount: advisorData['menteesCount'],
          phoneNumber: advisorData['phoneNumber'],
          photoUrl: advisorData['photoUrl'],
          rating: advisorData['rating'],
          reviewsCount: advisorData['reviewsCount'],
          uid: user.uid,
        );
        _role = true;
        _themeData = advisorTheme;
      } else {

        final studentData =
            await _firestoreService.getData(docPath: 'students/${user.uid}');
        //print(studentData.data);
        _student = Student(
          bio: studentData['bio'],
          displayName: studentData['displayName'],
          email: user.email,
          phoneNumber: 'test',
          photoUrl: studentData['photoUrl'],
          uid: user.uid,
        );
        _role = false;
        _themeData = studentTheme;
      }
      notifyListeners();
      return user.uid;
    } catch (error) {
      throw error;
    }

  }

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
    _advisor = null;
    _student = null;
    _role = false;
    _themeData = studentTheme;
    notifyListeners();
  }
}

ThemeData studentTheme = ThemeData(
  primaryColor: Color.fromRGBO(66, 133, 140, 1),
  accentColor: Colors.white,
  canvasColor: Colors.white,
  fontFamily: 'Literal',
  textTheme: TextTheme(headline6: TextStyle(fontSize: 20)),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.black54),
    textTheme: TextTheme(
      headline6:
          TextStyle(color: Color.fromRGBO(66, 133, 140, 1), fontSize: 22),
    ),
    elevation: 0,
  ),
);

ThemeData advisorTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Color.fromRGBO(13, 40, 107, 1),
  accentColor: Colors.white,
  canvasColor: Color.fromRGBO(244, 246, 252, 1),
  backgroundColor: Color.fromRGBO(253, 176, 94, 1),
  appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      color: Colors.white,
      elevation: 0),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
