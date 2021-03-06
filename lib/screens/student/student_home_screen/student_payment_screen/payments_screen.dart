import 'package:android/models/advisor_model.dart';
import 'package:android/screens/student/student_home_screen/student_slot_screen/user_time_slot.dart';
import 'package:android/screens/student/student_home_screen/student_payment_screen/constants.dart';
import 'package:android/services/advisor_database_provider.dart';
import 'package:android/services/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:android/services/student_database_provider.dart';
import 'package:android/models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'razorpay_flutter.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'razorpay_flutter.dart';
import 'constants.dart';
import 'paymentSuccess.dart';
import 'paymentFailed.dart';
import '../student_slot_screen/user_time_slot.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';

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
  Advisor advisor;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;



  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void initializing() async{
    androidInitializationSettings = AndroidInitializationSettings('no_bg');
    iosInitializationSettings = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(androidInitializationSettings,iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
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
    setNotification();
    updateDatabase();
    _razorpay.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => SuccessPage(
          response: response,
        ),
      ),
    );
    _razorpay.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("payment has error00000000000000000000000000000000000000");
    // Do something when payment fails
    _razorpay.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FailedPage(
          response: response,
        ),
      ),
    );
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("payment has externalWallet33333333333333333333333333");

    _razorpay.clear();
    // Do something when an external wallet is selected
  }

  void _showNotifications(int hours , int hourBefore, String advisorName) async{
    await notification(advisorName);
    //await notificationOnMeetingDay(10 ,'Meeting Today with $advisorName');
    await notificationOnMeetingDay(hourBefore,'Meeting with $advisorName in 1 hour');
  }

  Future<void> notification(String advisorname) async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hello there', 'Meeting with $advisorname scheduled ', notificationDetails);
  }

  Future<void> notificationOnMeetingDay(int hours ,String message) async {
    var timeDelayed = DateTime.now().add(Duration(seconds: hours));
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'second channel ID', 'second Channel title', 'second channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(1, 'Hello there',
        '$message', timeDelayed, notificationDetails);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }


  @override
  void initState() {
    initializing();
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


  setNotification(){

   //DateTime dateSelected = DateTime.parse(widget.userTimeSlot.);
   //Duration dur = DateTime.now().difference(dateSelected);
    print(widget.userTimeSlot.studentBookedSlotList[0]);
    print(widget.userTimeSlot.dateSelected);
    String date = widget.userTimeSlot.dateSelected;
    var bookedDate = DateFormat('d-M-yyyy').parse(date);
    print(bookedDate);
    print(DateTime.now().difference(bookedDate).inHours);
   int hours =  -DateTime.now().difference(bookedDate).inHours;
   String hourBefore = '';
   for(int i = 0 ;i<=1;++i){
      hourBefore = hourBefore+ widget.userTimeSlot.studentBookedSlotList[0][i];
     }
   int oneHrBefore = int.parse(hourBefore);
   print(oneHrBefore);
    _showNotifications(hours ,oneHrBefore, widget.userTimeSlot.advisorEmail);
  }

  void updateDatabase() {
    updateMentorDatabase();
    updateStudentDatabase();
  }

  void updateMentorDatabase() async{
    String dateSelected = widget.userTimeSlot.dateSelected;
    String path = '/helpers/${widget.userTimeSlot.advisorEmail}/freeSlots/$dateSelected';
    DocumentReference documentReference = Firestore.instance.document(path);
    AdvisorDatabaseProvider instance = AdvisorDatabaseProvider(advisor);
    await instance.confirmStudent(widget.userTimeSlot.advisorEmail, widget.userTimeSlot.studentUid, student.displayName);
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
    print('${widget.userTimeSlot.isDiscountApplied}');
    if(widget.userTimeSlot.isDiscountApplied == true){
      print('Entered coupon deletion');
      String path2   = 'students/${widget.userTimeSlot.studentUid}/coupons/${widget.userTimeSlot.discountId}';
      Firestore.instance.document(path2).delete().whenComplete(() => log('Coupon Deleted'));
    }

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

