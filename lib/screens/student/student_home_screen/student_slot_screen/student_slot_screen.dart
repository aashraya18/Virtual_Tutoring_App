import 'dart:async';
import 'package:android/models/student_model.dart';
import 'package:android/screens/student/student_home_screen/student_slot_screen/user_time_slot.dart';
import 'package:android/screens/screens.dart';
import 'package:android/screens/student/student_home_screen/student_payment_screen/order_id.dart';
import 'package:android/screens/student/student_home_screen/student_payment_screen/payments_screen.dart';
import 'package:android/services/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../common_widgets/bottomFlatButton.dart';
import '../../../../services/custom_icons_icons.dart';

class StudentSlotScreen extends StatefulWidget {
  static const routeName = '/student-slot';
  final advisor;
  final amount;
  final isDiscountApplied;
  final discountId;
  const StudentSlotScreen({this.advisor, this.amount,this.isDiscountApplied,this.discountId});

  @override
  _StudentSlotScreenState createState() => _StudentSlotScreenState();
}

class _StudentSlotScreenState extends State<StudentSlotScreen> {
  Student student;
  var selectedDate = DateTime.now().add(Duration(days: 1));
  var dat;
  var mon;
  var yer;
  List<dynamic> mentorNotBookedSlotList = List<dynamic>();
  List<dynamic> mentorBookedSlotList = List<dynamic>();
  List<dynamic> studentBookedSlotList = List<dynamic>();
  List<dynamic> mentorBookedList = List<dynamic>();
  bool isTrue = false;
  String selectedSlot;
  bool isLoading = false;

  @override
  void initState() {
    dat = selectedDate.day;
    mon = selectedDate.month;
    yer = selectedDate.year;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    student = Provider.of<AuthProvider>(context).student;
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          _buildText(),
          _buildDateList(constraints),
          SizedBox(
            height: 2.0,
          ),
          Text(
            'Mentor Slots Available',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  try {
                    mentorNotBookedSlotList = snapshot.data['NotBooked'];
                    mentorBookedSlotList = snapshot.data['Booked'];
                    return mentorNotBookedSlotList.length >= 1
                        ? Container(
                            padding: const EdgeInsets.all(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 3,
                              child:
                                  _buildMentorSlots(constraints: constraints),
                            ))
                        : Card(
                            child: Center(
                              child: Text(
                                "No Slots Available",
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          );
                  } catch (e) {
                    return Card(
                      child: Center(
                        child: Text(
                          "No Slots Available",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
//          SizedBox(
//            height: 2.0,
//          ),
//          Text(
//            'Mentor Slots Booked',
//            style: TextStyle(
//              fontWeight: FontWeight.bold,
//              fontSize: 15.0,
//            ),
//          ),
//          Expanded(
//            child: StreamBuilder(
//              stream: getData(),
//              builder: (context, snapshot) {
//                if (snapshot.hasData) {
//                  try {
//                    mentorBookedSlotList = snapshot.data['Booked'];
//                    return Container(
//                        padding: const EdgeInsets.all(20),
//                        child: Card(
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(15)),
//                          elevation: 3,
//                          child:
//                              _buildMentorBookedSlots(constraints: constraints),
//                        ));
//                  } catch (e) {
//                    return Card(
//                      child: Center(
//                        child: Text(
//                          "No Mentor Slots Booked",
//                          style: TextStyle(
//                            fontSize: 15.0,
//                          ),
//                        ),
//                      ),
//                    );
//                  }
//                }
//                return Center(
//                  child: CircularProgressIndicator(),
//                );
//              },
//            ),
//          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text(
              'Slot Selected',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Theme.of(context).primaryColor,
              disabledTextColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: isTrue
                    ? Text('$selectedSlot')
                    : Text(
                        "No Slot Selected",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
              ),
            ),
          ]),
          SizedBox(
            height: 5.0,
          ),
          isLoading
              ? Center(
                  child: Text('Please Wait.....'),
                )
              : BottomFlatButton(
                  iconData: CustomIcons.user_add_outline,
                  label: 'Schedule the Call',
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  iconSize: 25,
                  textSize: 18,
                  onPressed: _goToPaymentsScreen,
                ),
        ],
      ),
    );
  }

  Widget _buildText() {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select the Time Slot',
            style: TextStyle(fontSize: 22),
          ),
          Text(
            'for your call',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDateList(Size constraints) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 3,
      color: Theme.of(context).primaryColor,
      child: FlatButton(
        child: Text(
          DateFormat.yMMMd().format(selectedDate),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          final todayDate = DateTime.now();
          final date = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: todayDate.add(Duration(days: 1)),
            lastDate: todayDate.add(Duration(days: 6)),
          );
          if (date == null) {
            return;
          }
          setState(() {
            dat = date.day;
            mon = date.month;
            yer = date.year;
            selectedDate = date;
            getData();
          });
        },
      ),
    );
  }

  Widget _buildMentorSlots({constraints}) {
    return GridView.builder(
      itemCount: mentorNotBookedSlotList.length,
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: constraints.width / 2,
        childAspectRatio: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (ctx, index) => Center(
          child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: mentorBookedSlotList != null
            ? mentorBookedSlotList.contains(mentorNotBookedSlotList[index])
            ? null
            : () => _slotSelection(index)
            : () => _slotSelection(index),
        disabledTextColor: Colors.white,
        color: Color.fromRGBO(217, 243, 241, 1),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            '${mentorNotBookedSlotList[index]}',
          ),
        ),
      )),
    );
  }

  Widget _buildMentorBookedSlots({constraints}) {
    return GridView.builder(
      itemCount: mentorBookedSlotList.length,
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: constraints.width / 2,
        childAspectRatio: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (ctx, index) => Center(
          child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Color.fromRGBO(217, 243, 241, 1),
        disabledTextColor: Colors.white,
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Text('${mentorBookedSlotList[index]}')),
      )),
    );
  }

//  Widget _buildStudentSlots({constraints}) {
//    return GridView.builder(
//      itemCount: studentBookedSlotList.length,
//      padding: const EdgeInsets.all(20),
//      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//        maxCrossAxisExtent: constraints.width / 2,
//        childAspectRatio: 4,
//        mainAxisSpacing: 20,
//        crossAxisSpacing: 20,
//      ),
//      itemBuilder: (ctx, index) => Center(
//          child: RaisedButton(
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//        onPressed: () => _slotRemoval(index),
//        color: Color.fromRGBO(217, 243, 241, 1),
//        child: Container(
//            padding: const EdgeInsets.all(10),
//            child: Text('${studentBookedSlotList[index]}')),
//      )),
//    );
//  }

  Stream<DocumentSnapshot> getData() {
    String advisorEmail = '${widget.advisor.email}';
    String dateSelected = '$dat-$mon-$yer';
    String path = 'helpers/$advisorEmail/freeSlots/$dateSelected';
    return Firestore.instance.document(path).snapshots();
//    mentorNotBookedSlotList
//    log('$mentorNotBookedSlotList');
  }

  void _goToPaymentsScreen() async {
    setState(() {
      isLoading = true;
    });
    final userTimeSlot = storeData();
    final OrderId order = OrderId(
      mentorId: '${widget.advisor.uid}',
      mentorName: '${widget.advisor.displayName}',
      amount: widget.amount,
    );
    String orderId = await order.generateOrderId();
    if (isTrue) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => PaymentsScreen(
            cartTotal: widget.amount,
            mentorId: '${widget.advisor.uid}',
            mentorName: '${widget.advisor.displayName}',
            orderId: orderId,
            userTimeSlot: userTimeSlot,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => StudentDashboardScreen()));
    }
  }

  void _slotSelection(index) {
    setState(() {
      isTrue = true;
      selectedSlot = '${mentorNotBookedSlotList[index]}';
    });
  }

  UserTimeSlot storeData() {
    if (selectedSlot != "No Slot Selected") {
      studentBookedSlotList.add(selectedSlot);
//      if (studentBookedSlotList != 0) {
//        for (var value in studentBookedSlotList) {
//          if (mentorNotBookedSlotList.contains(value)) {
//            mentorNotBookedSlotList.remove(value);
//          }
//        }
//      }
      for (var value in studentBookedSlotList) {
        mentorBookedList.add(value);
      }
    }
    UserTimeSlot slotSelected = UserTimeSlot(
      studentBookedSlotList: studentBookedSlotList,
      mentorBookedList: mentorBookedList,
      dateSelected: '$dat-$mon-$yer',
      advisorEmail: '${widget.advisor.email}',
      mentorNotBookedSlotList: mentorNotBookedSlotList,
      studentEmail: '${student.email}',
      studentUid: '${student.uid}',
      discountId: '${widget.discountId}',
      isDiscountApplied: widget.isDiscountApplied,
    );
    return slotSelected;
  }

//  void _slotRemoval(int index) {
//    setState(() {
//      studentBookedSlotList.remove('${studentBookedSlotList[index]}');
//    });
//  }

  Stream<DocumentSnapshot> getStudentData() {
    String dateSelected = '$dat-$mon-$yer';
    String path =
        '/studentSlot/${student.email}/${widget.advisor.email}/$dateSelected';
    return Firestore.instance.document(path).snapshots();
  }
}
