import 'package:android/screens/student/student_home_screen/student_payment_screen/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

class TransferPayment {

  final double amount;
  final String accountId;
  final String mentorName;
  final String mentorId;

  TransferPayment({
    this.amount: 2000,    // This is in the smallest currency sub-unit i.e paisa.
    this.accountId: 'acc_EqDkbQSjjSfnSt',
    this.mentorName: 'Alexa',
    this.mentorId: '1337',
  });

  final String keyId = Constants.keyId;
  final String keyValue = Constants.keyValue;
  String transferId;

  void transfer() async {
    String apiUrl =
        'https://$keyId:$keyValue@api.razorpay.com/v1/transfers';
    final http.Response response = await http.post(
      apiUrl,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<dynamic, dynamic>{
        "transfers": [
          {
            "account": "$accountId",
            "amount": amount,
            "currency": "INR",
            "notes": {
              "name": '$mentorName',
              "roll_no": "$mentorId"
            },
            "on_hold": false
          }
        ]
      }),
    );
    log('${response.body}');
    if (response.statusCode == 200) {
      log('Payment is transferred');
      var extractData = jsonDecode(response.body);
      return transferId = extractData['id'];
    }
    return null;
  }

}
