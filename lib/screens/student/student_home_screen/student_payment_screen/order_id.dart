import 'file:///D:/FlutterDevelopment/vorby_app/lib/screens/student/student_home_screen/student_slot_screen/user_time_slot.dart';
import 'package:android/screens/student/student_home_screen/student_payment_screen/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'payments_screen.dart';

class OrderId{
  final double amount;
  final String mentorName;
  final String mentorId;

  const OrderId({
    this.amount: 2000,
    this.mentorName: 'Alexa',
    this.mentorId: '1337',
  });

  Future<String> generateOrderId() async {
    String keyId = Constants.keyId;
    String keyValue = Constants.keyValue;
    String orderId;
    String apiUrl = 'https://$keyId:$keyValue@api.razorpay.com/v1/orders';
    final http.Response response2 = await http.post(
      apiUrl,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(
          <dynamic, dynamic>{"amount": amount, "currency": "INR","notes" : {"mentorName" : mentorName , "mentorId" : mentorId}}),
    );
    log('${response2.body}');
    var extractData = jsonDecode(response2.body);
    orderId = extractData['id'];
    return orderId;
  }
}
