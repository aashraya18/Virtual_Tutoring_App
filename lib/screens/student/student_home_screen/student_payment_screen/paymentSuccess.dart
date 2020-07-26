import 'package:android/screens/screens.dart';
import 'package:flutter/material.dart';
import 'razorpay_flutter.dart';


class SuccessPage extends StatelessWidget {

  final PaymentSuccessResponse response;
  SuccessPage({
    @required this.response,
  });




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Success"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Your payment is successful and the response is\n\n PaymentId: ${response.paymentId}  \n\n OrderId: ${response.orderId} \n\n Signature: ${response.signature}",
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
                Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
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
