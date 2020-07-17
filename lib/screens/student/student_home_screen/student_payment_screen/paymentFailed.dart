import 'package:android/screens/student/student_dashboard_screen/student_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'razorpay_flutter.dart';

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
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil('/student-dashboard', (Route<dynamic> route) => false);
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
