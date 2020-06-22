import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

import './constants.dart';
import './payments_screen.dart';

class OrderId extends StatefulWidget {
  static const routeName = '/user-orderId';
  final double amount;
  final String mentorName;
  final String mentorId;
  final String mentorEmail;

  const OrderId(
      {this.amount: 2000,
      this.mentorName: 'Alexa',
      this.mentorId: '1337',
      this.mentorEmail: 'test@advisor.com'});

  @override
  _OrderIdState createState() => _OrderIdState();
}

class _OrderIdState extends State<OrderId> {
  String keyId = Constants().keyId;
  String keyValue = Constants().keyValue;
  String orderId;

  Future<void> generateOrderId() async {
    String apiUrl = 'https://$keyId:$keyValue@api.razorpay.com/v1/orders';
    final http.Response response2 = await http.post(
      apiUrl,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(
          <dynamic, dynamic>{"amount": widget.amount, "currency": "INR"}),
    );
    log('${response2.body}');
    var extractData = jsonDecode(response2.body);
    orderId = extractData['id'];
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => PaymentsScreen(
              cartTotal: widget.amount,
//      accountId: widget.accountId,
              mentorId: widget.mentorId,
              mentorName: widget.mentorName,
              orderId: orderId,
              mentorEmail: widget.mentorEmail,
            )));
  }

  @override
  void initState() {
    super.initState();
    generateOrderId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
