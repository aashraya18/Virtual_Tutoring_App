import 'package:android/screens/student/student_home_screen/student_slot_screen/user_time_slot.dart';
import 'package:android/screens/student/student_home_screen/student_payment_screen/constants.dart';
import 'package:android/services/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:android/services/student_database_provider.dart';
import 'package:android/models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'razorpay_flutter.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'razorpay_flutter.dart';
import 'constants.dart';
import 'paymentSuccess.dart';
import 'paymentFailed.dart';
import '../student_slot_screen/user_time_slot.dart';

class PaymentsScreen extends StatefulWidget {
  static const routeName = '/user-payments';
  final double cartTotal;
  final String mentorName;
  final String mentorId;
  final String orderId;
  final UserTimeSlot userTimeSlot;

  const PaymentsScreen({
    Key key,
    this.cartTotal: 2000,
    this.mentorName: 'Alexa',
    this.mentorId: '1337',
    this.orderId,
    this.userTimeSlot,
  }) : super(key: key);
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  Razorpay _razorpay = Razorpay();
  var options;
  String keyId = Constants.keyId;
  String keyValue = Constants.keyValue;
  String orderId;
  Student student;
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future payData() async {
    try {
      _razorpay.open(options);
    } catch (e) {
      print("errror occured here is ......................./:$e");
    }

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void capturePayment(PaymentSuccessResponse response) async {
    String apiUrl =
        'https://$keyId:$keyValue@api.razorpay.com/v1/payments/${response.paymentId}/capture';
    final http.Response response2 = await http.post(
      apiUrl,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<dynamic, dynamic>{
        "amount": widget.cartTotal,
        "currency": "INR",
      }),
    );
    if (response2.statusCode == 200) {
      log('Payment is captured');
    }
  }

  void checkout() {}

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log("payment has succedded");
    // Do something when payment succeeds
    capturePayment(response);
    updateDatabase();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SuccessPage(
          response: response,
        ),
      ),
          (Route<dynamic> route) => false,
    );
    _razorpay.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("payment has error00000000000000000000000000000000000000");
    // Do something when payment fails
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FailedPage(
          response: response,
        ),
      ),
          (Route<dynamic> route) => false,
    );
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("payment has externalWallet33333333333333333333333333");

    _razorpay.clear();
    // Do something when an external wallet is selected
  }

  @override
  void initState() {
    RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    String stringMoney = widget.cartTotal.toString().replaceAll(regex, '');
    int totalMoney = int.parse(stringMoney);
    log('$totalMoney');
    super.initState();
    options = {
      'key': '$keyId', // Enter the Key ID generated from the Dashboard
      'amount': totalMoney, //in the smallest currency sub-unit.
      'name': 'Vorby',
      'currency': "INR",
      'order_id': widget.orderId,
      'theme.color': '0xFF42858c',
      'buttontext': "Vorby",
      'description': 'paymentsTest',
      'prefill': {
        'contact': '',
        'email': '',
      }
    };
  }


  void updateDatabase() {
    updateMentorDatabase();
    updateStudentDatabase();
  }

  void updateMentorDatabase() {
    String dateSelected = widget.userTimeSlot.dateSelected;
    String path = '/helpers/${widget.userTimeSlot.advisorEmail}/freeSlots/$dateSelected';
    DocumentReference documentReference = Firestore.instance.document(path);
    Map<String, dynamic> mentorSlot = {
//      'NotBooked': widget.userTimeSlot.mentorNotBookedSlotList,
      'Booked': FieldValue.arrayUnion(widget.userTimeSlot.mentorBookedList),
    };
    documentReference.updateData(mentorSlot).whenComplete(() {
      log('completed');
    });
    log('Mentor List: ${widget.userTimeSlot.mentorNotBookedSlotList}');
  }

  void updateStudentDatabase() async{
    log('Student List: ${widget.userTimeSlot.studentBookedSlotList}');
    String dateSelected = widget.userTimeSlot.dateSelected;
    log('Student Uid: ${widget.userTimeSlot.studentUid}');
    log('${widget.userTimeSlot.advisorEmail}');
    log('$dateSelected');
    StudentDatabaseProvider instance = StudentDatabaseProvider(student);
    await instance.bookAdvisor('${widget.userTimeSlot.advisorEmail}');
    String path = '/students/${widget.userTimeSlot.studentUid}/advisors/${widget.userTimeSlot.advisorEmail}/slotBooking/$dateSelected';
    DocumentReference documentReference = Firestore.instance.document(path);
    Map<String, dynamic> studentSlot = {
      'Booked': FieldValue.arrayUnion(widget.userTimeSlot.studentBookedSlotList),
    };
    documentReference.setData(studentSlot, merge: true).whenComplete(() {
      log('completeddone');
    });
  }
  @override
  Widget build(BuildContext context) {
    // print("razor runtime --------: ${_razorpay.runtimeType}");
    student = Provider.of<AuthProvider>(context, listen: false).student;
    return Scaffold(
      body: FutureBuilder(
          future: payData(),
          builder: (context, snapshot) {
            return Container(
              child: Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }),
    );
  }
}

//  void transferPayment(PaymentSuccessResponse response) async {
//    String apiUrl =
//        'https://$keyId:$keyValue@api.razorpay.com/v1/payments/${response.paymentId}/transfers';
//    final http.Response response2 = await http.post(
//      apiUrl,
//      headers: <String, String>{'Content-Type': 'application/json'},
//      body: jsonEncode(<dynamic, dynamic>{
//        "transfers": [
//          {
//            "account": "${widget.accountId}",
//            "amount": widget.cartTotal * 0.4,
//            "currency": "INR",
//            "notes": {
//              "name": '${widget.mentorName}',
//              "roll_no": "${widget.mentorId}"
//            },
//            "linked_account_notes": ["roll_no"],
//            "on_hold": false
//          }
//        ]
//      }),
//    );
//    log('${response2.body}');
//    if (response2.statusCode == 200) {
//      log('Payment is transferred');
//    }
//  }

//  void signatureVerification(PaymentSuccessResponse response){
//    String dataIn  = '${response.paymentId}+"|" +${response.orderId}';
//    String signature = keyValue;
//    String generatedSignature;
//    var encodedKey = utf8.encode(signature); // signature=encryption key
//    var hmacSha256 = new Hmac(sha256, encodedKey); // HMAC-SHA256 with key
//    var bytesDataIn = utf8.encode(dataIn);   // encode the data to Unicode.
//    var digest = hmacSha256.convert(bytesDataIn);  // encrypt target data
//    generatedSignature = digest.toString();
//
//    if(generatedSignature == response.signature){
//      log('Signature Verified');
//    }else{
//      log('not verified: $generatedSignature');
//    }
//
//  }
