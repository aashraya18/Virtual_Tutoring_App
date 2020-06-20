import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../screen_decider.dart';

class FailedPage extends StatelessWidget {
  final PaymentFailureResponse response;
  FailedPage({
    @required this.response,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Failed"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Your payment is Failed and the response is\n Code: ${response.code}\nMessage: ${response.message}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ScreenDecider.routeName);
              },
              color: Color.fromRGBO(66, 133, 140, 1),
              textColor: Colors.white,
              child: Text('OK'),
            )
          ],
        ),
      ),
    );
  }
}
